import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../helpers/mock_repositories.dart';

void main() {
  late MockChatSettingsRepository repo;
  const saved = ChatSettings(chatId: 'c1', isMuted: true);
  const changed = ChatSettings(chatId: 'c1', isMuted: true, isProtected: true);

  setUpAll(() => registerFallbackValue(const ChatSettings(chatId: '')));

  setUp(() => repo = MockChatSettingsRepository());

  void stubFetch() {
    when(() => repo.fetchSettings('c1')).thenAnswer((_) async => saved);
  }

  group('load', () {
    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'emits the saved settings without a loading state in between',
      build: () {
        stubFetch();
        return ChatSettingsCubit(repo);
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatSettingsState>()
            .having((s) => s.status, 'status', ChatSettingsStatus.success)
            .having((s) => s.settings.chatId, 'chatId', 'c1')
            .having((s) => s.settings.isMuted, 'isMuted', true),
      ],
    );

    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'emits the Supabase message on PostgrestException',
      build: () {
        when(() => repo.fetchSettings('c1')).thenThrow(
            const PostgrestException(message: 'permission denied'));
        return ChatSettingsCubit(repo);
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatSettingsState>()
            .having((s) => s.status, 'status', ChatSettingsStatus.failure)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'emits a safe generic message on unknown errors',
      build: () {
        when(() => repo.fetchSettings('c1'))
            .thenThrow(Exception('socket closed'));
        return ChatSettingsCubit(repo);
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatSettingsState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );

    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'keeps the shown settings when a refresh fails',
      build: () {
        var calls = 0;
        when(() => repo.fetchSettings('c1')).thenAnswer((_) async {
          if (++calls == 1) return saved;
          throw Exception('socket closed');
        });
        return ChatSettingsCubit(repo);
      },
      act: (cubit) async {
        await cubit.load('c1');
        await cubit.load('c1');
      },
      skip: 1,
      expect: () => [
        isA<ChatSettingsState>()
            .having((s) => s.status, 'status', ChatSettingsStatus.success)
            .having((s) => s.settings.isMuted, 'isMuted', true)
            .having((s) => s.error, 'error', isNotNull),
      ],
    );
  });

  group('update', () {
    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'shows the new settings and saves them',
      build: () {
        stubFetch();
        when(() => repo.saveSettings(any())).thenAnswer((_) async {});
        return ChatSettingsCubit(repo);
      },
      act: (cubit) async {
        await cubit.load('c1');
        await cubit.update(changed);
      },
      skip: 1,
      expect: () => [
        isA<ChatSettingsState>()
            .having((s) => s.settings.isProtected, 'isProtected', true)
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (_) => verify(() => repo.saveSettings(changed)).called(1),
    );

    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'goes back to the previous settings when saving fails',
      build: () {
        stubFetch();
        when(() => repo.saveSettings(any()))
            .thenThrow(const PostgrestException(message: 'permission denied'));
        return ChatSettingsCubit(repo);
      },
      act: (cubit) async {
        await cubit.load('c1');
        await cubit.update(changed);
      },
      skip: 1,
      expect: () => [
        isA<ChatSettingsState>()
            .having((s) => s.settings.isProtected, 'isProtected', true),
        isA<ChatSettingsState>()
            .having((s) => s.settings.isProtected, 'isProtected', false)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'reverts with a safe generic message on unknown errors',
      build: () {
        stubFetch();
        when(() => repo.saveSettings(any()))
            .thenThrow(Exception('socket closed'));
        return ChatSettingsCubit(repo);
      },
      act: (cubit) async {
        await cubit.load('c1');
        await cubit.update(changed);
      },
      skip: 2,
      expect: () => [
        isA<ChatSettingsState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );

    blocTest<ChatSettingsCubit, ChatSettingsState>(
      'does nothing before the settings are loaded',
      build: () => ChatSettingsCubit(repo),
      act: (cubit) => cubit.update(changed),
      expect: () => <ChatSettingsState>[],
      verify: (_) => verifyNever(() => repo.saveSettings(any())),
    );
  });
}
