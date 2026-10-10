import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_cubit.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../helpers/mock_repositories.dart';

void main() {
  late MockMessagesRepository repo;

  setUp(() {
    repo = MockMessagesRepository();
    when(() => repo.currentUserId).thenReturn('me');
  });

  Message message(String id, String senderId, String text, int minute) =>
      Message(
        id: id,
        chatId: 'c1',
        senderId: senderId,
        text: text,
        createdAt: DateTime(2026, 9, 27, 10, minute),
      );

  void stubFetch() {
    when(() => repo.fetchMessages('c1'))
        .thenAnswer((_) async => [message('1', 'david', 'Hello!', 10)]);
  }

  group('loadMessages', () {
    blocTest<ConversationCubit, ConversationState>(
      'emits messages newest first with time labels and ownership',
      build: () {
        when(() => repo.fetchMessages('c1')).thenAnswer((_) async => [
              message('1', 'david', 'Hello!', 10),
              message('2', 'me', 'Hi!', 12),
            ]);
        return ConversationCubit(repo);
      },
      act: (cubit) => cubit.loadMessages('c1'),
      expect: () => [
        isA<ConversationState>()
            .having((s) => s.status, 'status', ConversationStatus.loading),
        isA<ConversationState>()
            .having((s) => s.status, 'status', ConversationStatus.success)
            .having((s) => s.messages.map((m) => m.id).toList(), 'ids',
                ['2', '1'])
            .having((s) => s.messages.first.isMine, 'newest is mine', true)
            .having((s) => s.messages.first.timeLabel, 'newest label', '10:12')
            .having((s) => s.messages.last.isMine, 'oldest is mine', false)
            .having((s) => s.messages.last.text, 'oldest text', 'Hello!'),
      ],
    );

    blocTest<ConversationCubit, ConversationState>(
      'emits the Supabase message on PostgrestException',
      build: () {
        when(() => repo.fetchMessages('c1')).thenThrow(
            const PostgrestException(message: 'permission denied'));
        return ConversationCubit(repo);
      },
      act: (cubit) => cubit.loadMessages('c1'),
      expect: () => [
        isA<ConversationState>()
            .having((s) => s.status, 'status', ConversationStatus.loading),
        isA<ConversationState>()
            .having((s) => s.status, 'status', ConversationStatus.failure)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<ConversationCubit, ConversationState>(
      'emits a safe generic message on unknown errors',
      build: () {
        when(() => repo.fetchMessages('c1'))
            .thenThrow(Exception('socket closed'));
        return ConversationCubit(repo);
      },
      act: (cubit) => cubit.loadMessages('c1'),
      skip: 1,
      expect: () => [
        isA<ConversationState>()
            .having((s) => s.status, 'status', ConversationStatus.failure)
            .having(
              (s) => s.error?.message,
              'error',
              'Something went wrong. Please try again.',
            ),
      ],
    );
  });

  group('sendMessage', () {
    blocTest<ConversationCubit, ConversationState>(
      'sends the trimmed text and puts the new message first',
      build: () {
        stubFetch();
        when(() => repo.sendMessage(chatId: 'c1', text: 'On my way'))
            .thenAnswer((_) async => message('2', 'me', 'On my way', 15));
        return ConversationCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadMessages('c1');
        await cubit.sendMessage('  On my way  ');
      },
      skip: 2,
      expect: () => [
        isA<ConversationState>()
            .having((s) => s.messages.map((m) => m.id).toList(), 'ids',
                ['2', '1'])
            .having((s) => s.messages.first.text, 'text', 'On my way')
            .having((s) => s.messages.first.isMine, 'isMine', true)
            .having((s) => s.messages.first.timeLabel, 'label', '10:15'),
      ],
      verify: (_) {
        verify(() => repo.sendMessage(chatId: 'c1', text: 'On my way'))
            .called(1);
      },
    );

    blocTest<ConversationCubit, ConversationState>(
      'ignores a blank message',
      build: () {
        stubFetch();
        return ConversationCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadMessages('c1');
        await cubit.sendMessage('   ');
      },
      skip: 2,
      expect: () => <ConversationState>[],
      verify: (_) {
        verifyNever(() => repo.sendMessage(
              chatId: any(named: 'chatId'),
              text: any(named: 'text'),
            ));
      },
    );

    blocTest<ConversationCubit, ConversationState>(
      'does nothing before a chat is loaded',
      build: () => ConversationCubit(repo),
      act: (cubit) => cubit.sendMessage('Hi!'),
      expect: () => <ConversationState>[],
      verify: (_) {
        verifyNever(() => repo.sendMessage(
              chatId: any(named: 'chatId'),
              text: any(named: 'text'),
            ));
      },
    );

    blocTest<ConversationCubit, ConversationState>(
      'emits an error and keeps the messages when sending fails',
      build: () {
        stubFetch();
        when(() => repo.sendMessage(chatId: 'c1', text: 'Hi!'))
            .thenThrow(const PostgrestException(message: 'permission denied'));
        return ConversationCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadMessages('c1');
        await cubit.sendMessage('Hi!');
      },
      skip: 2,
      expect: () => [
        isA<ConversationState>()
            .having((s) => s.status, 'status', ConversationStatus.success)
            .having((s) => s.messages.length, 'messages', 1)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<ConversationCubit, ConversationState>(
      'emits a safe generic message when sending fails for unknown reasons',
      build: () {
        stubFetch();
        when(() => repo.sendMessage(chatId: 'c1', text: 'Hi!'))
            .thenThrow(Exception('socket closed'));
        return ConversationCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadMessages('c1');
        await cubit.sendMessage('Hi!');
      },
      skip: 2,
      expect: () => [
        isA<ConversationState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );
  });
}
