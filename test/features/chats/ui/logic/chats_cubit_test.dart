import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/chat.dart';
import 'package:e_chat_app/features/chats/domain/repo/chats_repository.dart';
import 'package:e_chat_app/features/chats/ui/logic/chats_cubit.dart';
import 'package:e_chat_app/features/chats/ui/logic/chats_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

void main() {
  late MockChatsRepository repo;
  final now = DateTime(2026, 9, 27, 18, 0);

  setUp(() => repo = MockChatsRepository());

  ChatsCubit buildCubit() => ChatsCubit(repo, now: () => now);

  blocTest<ChatsCubit, ChatsState>(
    'loadChats emits previews sorted newest first with time labels',
    build: () {
      when(() => repo.fetchChats()).thenAnswer((_) async => [
            Chat(
              id: 'old',
              name: 'Rodolfo Walter',
              lastMessage: 'Appreciate it!',
              lastMessageAt: DateTime(2026, 5, 1, 7, 55),
            ),
            Chat(
              id: 'today',
              name: 'David Wayne',
              lastMessage: 'Thanks!',
              lastMessageAt: DateTime(2026, 9, 27, 10, 25),
              unreadCount: 5,
            ),
          ]);
      return buildCubit();
    },
    act: (cubit) => cubit.loadChats(),
    expect: () => [
      isA<ChatsState>().having((s) => s.status, 'status', ChatsStatus.loading),
      isA<ChatsState>()
          .having((s) => s.status, 'status', ChatsStatus.success)
          .having(
              (s) => s.chats.map((c) => c.id).toList(), 'ids', ['today', 'old'])
          .having((s) => s.chats.first.timeLabel, 'first label', '10:25')
          .having((s) => s.chats.last.timeLabel, 'last label', '07:55  01/05')
          .having((s) => s.chats.first.unreadCount, 'unread', 5),
    ],
  );

  blocTest<ChatsCubit, ChatsState>(
    'loadChats emits the Supabase message on PostgrestException',
    build: () {
      when(() => repo.fetchChats())
          .thenThrow(const PostgrestException(message: 'permission denied'));
      return buildCubit();
    },
    act: (cubit) => cubit.loadChats(),
    expect: () => [
      isA<ChatsState>().having((s) => s.status, 'status', ChatsStatus.loading),
      isA<ChatsState>()
          .having((s) => s.status, 'status', ChatsStatus.failure)
          .having((s) => s.error?.message, 'error', 'permission denied'),
    ],
  );

  blocTest<ChatsCubit, ChatsState>(
    'loadChats emits a safe generic message on unknown errors',
    build: () {
      when(() => repo.fetchChats()).thenThrow(Exception('socket closed'));
      return buildCubit();
    },
    act: (cubit) => cubit.loadChats(),
    expect: () => [
      isA<ChatsState>().having((s) => s.status, 'status', ChatsStatus.loading),
      isA<ChatsState>().having(
        (s) => s.error?.message,
        'error',
        'Something went wrong. Please try again.',
      ),
    ],
  );

  group('search', () {
    List<Chat> sampleChats() => [
          Chat(
            id: '1',
            name: 'David Wayne',
            lastMessage: 'Thanks a bunch!',
            lastMessageAt: DateTime(2026, 9, 27, 10, 25),
          ),
          Chat(
            id: '2',
            name: 'Jean Dare',
            lastMessage: 'Hooray!',
            lastMessageAt: DateTime(2026, 9, 26, 20, 10),
          ),
        ];

    blocTest<ChatsCubit, ChatsState>(
      'search filters by name or last message, case-insensitive',
      build: () {
        when(() => repo.fetchChats()).thenAnswer((_) async => sampleChats());
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.loadChats();
        cubit.search('JEAN');
        cubit.search('thanks');
      },
      skip: 2,
      expect: () => [
        isA<ChatsState>()
            .having((s) => s.chats.map((c) => c.id), 'ids', ['2']).having(
                (s) => s.allChats.length, 'allChats', 2),
        isA<ChatsState>().having((s) => s.chats.map((c) => c.id), 'ids', ['1']),
      ],
    );

    blocTest<ChatsCubit, ChatsState>(
      'closeSearch clears the query and restores the full list',
      build: () {
        when(() => repo.fetchChats()).thenAnswer((_) async => sampleChats());
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.loadChats();
        cubit.openSearch();
        cubit.search('jean');
        cubit.closeSearch();
      },
      skip: 4,
      expect: () => [
        isA<ChatsState>()
            .having((s) => s.isSearchOpen, 'isSearchOpen', false)
            .having((s) => s.searchQuery, 'query', '')
            .having((s) => s.chats.length, 'chats', 2),
      ],
    );
  });

  group('add menu', () {
    blocTest<ChatsCubit, ChatsState>(
      'toggleAddMenu opens then closes the menu',
      build: buildCubit,
      act: (cubit) => cubit
        ..toggleAddMenu()
        ..toggleAddMenu(),
      expect: () => [
        isA<ChatsState>().having((s) => s.isAddMenuOpen, 'open', true),
        isA<ChatsState>().having((s) => s.isAddMenuOpen, 'open', false),
      ],
    );

    blocTest<ChatsCubit, ChatsState>(
      'openSearch closes an open add menu',
      build: buildCubit,
      act: (cubit) => cubit
        ..toggleAddMenu()
        ..openSearch(),
      skip: 1,
      expect: () => [
        isA<ChatsState>()
            .having((s) => s.isSearchOpen, 'search', true)
            .having((s) => s.isAddMenuOpen, 'menu', false),
      ],
    );

    blocTest<ChatsCubit, ChatsState>(
      'closeAddMenu does nothing when the menu is already closed',
      build: buildCubit,
      act: (cubit) => cubit.closeAddMenu(),
      expect: () => <ChatsState>[],
    );
  });
}
