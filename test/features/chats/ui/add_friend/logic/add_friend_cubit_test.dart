import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/add_friend/logic/add_friend_cubit.dart';
import 'package:e_chat_app/features/chats/ui/add_friend/logic/add_friend_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../helpers/mock_repositories.dart';

void main() {
  late MockFriendsRepository repo;

  const cayla = Friend(id: '6', name: 'Cayla Rath', phoneNumber: '+44509285');
  const erin = Friend(id: '7', name: 'Erin Turcotte', phoneNumber: '+44509');

  setUp(() => repo = MockFriendsRepository());

  AddFriendCubit buildCubit() => AddFriendCubit(repo);

  group('search', () {
    blocTest<AddFriendCubit, AddFriendState>(
      'emits results for the dial code plus typed digits',
      build: () {
        when(() => repo.searchByPhone('+44509285'))
            .thenAnswer((_) async => [cayla]);
        return buildCubit();
      },
      act: (cubit) => cubit.search(dialCode: '+44', number: '50 9285'),
      expect: () => [
        isA<AddFriendState>()
            .having((s) => s.status, 'status', AddFriendStatus.loading)
            .having((s) => s.dialCode, 'dialCode', '+44')
            .having((s) => s.number, 'number', '509285'),
        isA<AddFriendState>()
            .having((s) => s.status, 'status', AddFriendStatus.success)
            .having((s) => s.results.map((f) => f.id), 'ids', ['6']),
      ],
    );

    blocTest<AddFriendCubit, AddFriendState>(
      'an empty number clears the results without calling the repository',
      build: () {
        when(() => repo.searchByPhone(any())).thenAnswer((_) async => [cayla]);
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.search(dialCode: '+44', number: '5');
        await cubit.search(dialCode: '+44', number: '');
      },
      skip: 2,
      expect: () => [
        isA<AddFriendState>()
            .having((s) => s.status, 'status', AddFriendStatus.initial)
            .having((s) => s.number, 'number', '')
            .having((s) => s.results, 'results', isEmpty),
      ],
      verify: (_) => verify(() => repo.searchByPhone('+445')).called(1),
    );

    blocTest<AddFriendCubit, AddFriendState>(
      'drops a response that arrives after a newer query',
      build: buildCubit,
      act: (cubit) async {
        final slow = Completer<List<Friend>>();
        when(() => repo.searchByPhone('+445')).thenAnswer((_) => slow.future);
        when(() => repo.searchByPhone('+4450'))
            .thenAnswer((_) async => [cayla]);

        final first = cubit.search(dialCode: '+44', number: '5');
        await cubit.search(dialCode: '+44', number: '50');
        slow.complete([erin]);
        await first;
      },
      skip: 2,
      expect: () => [
        isA<AddFriendState>()
            .having((s) => s.status, 'status', AddFriendStatus.success)
            .having((s) => s.results.map((f) => f.id), 'ids', ['6']),
      ],
    );

    blocTest<AddFriendCubit, AddFriendState>(
      'emits the Supabase message on PostgrestException',
      build: () {
        when(() => repo.searchByPhone(any()))
            .thenThrow(const PostgrestException(message: 'permission denied'));
        return buildCubit();
      },
      act: (cubit) => cubit.search(dialCode: '+44', number: '5'),
      skip: 1,
      expect: () => [
        isA<AddFriendState>()
            .having((s) => s.status, 'status', AddFriendStatus.failure)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<AddFriendCubit, AddFriendState>(
      'emits a safe generic message on unknown errors',
      build: () {
        when(() => repo.searchByPhone(any()))
            .thenThrow(Exception('socket closed'));
        return buildCubit();
      },
      act: (cubit) => cubit.search(dialCode: '+44', number: '5'),
      skip: 1,
      expect: () => [
        isA<AddFriendState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );
  });

  group('addFriend', () {
    blocTest<AddFriendCubit, AddFriendState>(
      'marks the user as added',
      build: () {
        when(() => repo.addFriend('6')).thenAnswer((_) async {});
        return buildCubit();
      },
      act: (cubit) => cubit.addFriend('6'),
      expect: () => [
        isA<AddFriendState>().having((s) => s.addedIds, 'addedIds', {'6'}),
      ],
    );

    blocTest<AddFriendCubit, AddFriendState>(
      'emits an error and leaves the user un-added on failure',
      build: () {
        when(() => repo.addFriend('6'))
            .thenThrow(const PostgrestException(message: 'duplicate key'));
        return buildCubit();
      },
      act: (cubit) => cubit.addFriend('6'),
      expect: () => [
        isA<AddFriendState>()
            .having((s) => s.error?.message, 'error', 'duplicate key')
            .having((s) => s.addedIds, 'addedIds', isEmpty),
      ],
    );
  });
}
