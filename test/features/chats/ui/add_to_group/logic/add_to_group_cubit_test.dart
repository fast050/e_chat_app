import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/group.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../helpers/mock_repositories.dart';

void main() {
  late MockGroupsRepository repo;
  const groups = [
    Group(id: 'g1', name: 'Diamond Team', memberIds: ['u2']),
    Group(id: 'g2', name: 'Delivery', memberIds: ['u1', 'u3']),
    Group(id: 'g3', name: 'IT Training', memberIds: []),
  ];

  setUp(() => repo = MockGroupsRepository());

  void stubFetch() {
    when(() => repo.fetchGroups()).thenAnswer((_) async => groups);
  }

  List<String> ids(AddToGroupState state) =>
      state.groups.map((group) => group.id).toList();

  group('loadGroups', () {
    blocTest<AddToGroupCubit, AddToGroupState>(
      'emits the groups and marks the ones the user is already in',
      build: () {
        stubFetch();
        return AddToGroupCubit(repo);
      },
      act: (cubit) => cubit.loadGroups('u1'),
      expect: () => [
        isA<AddToGroupState>()
            .having((s) => s.status, 'status', AddToGroupStatus.success)
            .having(ids, 'ids', ['g1', 'g2', 'g3'])
            .having((s) => s.addedIds, 'addedIds', {'g2'}),
      ],
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'emits the Supabase message on PostgrestException',
      build: () {
        when(() => repo.fetchGroups()).thenThrow(
            const PostgrestException(message: 'permission denied'));
        return AddToGroupCubit(repo);
      },
      act: (cubit) => cubit.loadGroups('u1'),
      expect: () => [
        isA<AddToGroupState>()
            .having((s) => s.status, 'status', AddToGroupStatus.failure)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'emits a safe generic message on unknown errors',
      build: () {
        when(() => repo.fetchGroups()).thenThrow(Exception('socket closed'));
        return AddToGroupCubit(repo);
      },
      act: (cubit) => cubit.loadGroups('u1'),
      expect: () => [
        isA<AddToGroupState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'keeps the search when reloading after a group was created',
      build: () {
        var calls = 0;
        when(() => repo.fetchGroups()).thenAnswer((_) async {
          if (++calls == 1) return groups;
          return const [
            Group(id: 'g4', name: 'Delivery Drivers', memberIds: []),
            ...groups,
          ];
        });
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        cubit.search('deliv');
        await cubit.loadGroups('u1');
      },
      skip: 2,
      expect: () => [
        isA<AddToGroupState>()
            .having((s) => s.status, 'status', AddToGroupStatus.success)
            .having((s) => s.searchQuery, 'searchQuery', 'deliv')
            .having(ids, 'ids', ['g4', 'g2']),
      ],
    );
  });

  group('search', () {
    blocTest<AddToGroupCubit, AddToGroupState>(
      'filters by name, ignoring case and outer spaces',
      build: () {
        stubFetch();
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        cubit.search('  TRAIN ');
      },
      skip: 1,
      expect: () => [
        isA<AddToGroupState>().having(ids, 'ids', ['g3']),
      ],
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'shows every group again when the search is cleared',
      build: () {
        stubFetch();
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        cubit
          ..search('zzz')
          ..search('');
      },
      skip: 1,
      expect: () => [
        isA<AddToGroupState>().having(ids, 'ids', isEmpty),
        isA<AddToGroupState>().having(ids, 'ids', ['g1', 'g2', 'g3']),
      ],
    );
  });

  group('addToGroup', () {
    blocTest<AddToGroupCubit, AddToGroupState>(
      'adds the user and marks the group as added',
      build: () {
        stubFetch();
        when(() => repo.addMember(groupId: 'g1', userId: 'u1'))
            .thenAnswer((_) async {});
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        await cubit.addToGroup('g1');
      },
      skip: 1,
      expect: () => [
        isA<AddToGroupState>()
            .having((s) => s.addedIds, 'addedIds', {'g1', 'g2'}),
      ],
      verify: (_) {
        verify(() => repo.addMember(groupId: 'g1', userId: 'u1')).called(1);
      },
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'ignores a group the user is already in',
      build: () {
        stubFetch();
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        await cubit.addToGroup('g2');
      },
      skip: 1,
      expect: () => <AddToGroupState>[],
      verify: (_) {
        verifyNever(() => repo.addMember(
              groupId: any(named: 'groupId'),
              userId: any(named: 'userId'),
            ));
      },
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'does nothing before the groups are loaded',
      build: () => AddToGroupCubit(repo),
      act: (cubit) => cubit.addToGroup('g1'),
      expect: () => <AddToGroupState>[],
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'emits an error and leaves the group un-added when adding fails',
      build: () {
        stubFetch();
        when(() => repo.addMember(groupId: 'g1', userId: 'u1'))
            .thenThrow(const PostgrestException(message: 'permission denied'));
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        await cubit.addToGroup('g1');
      },
      skip: 1,
      expect: () => [
        isA<AddToGroupState>()
            .having((s) => s.addedIds, 'addedIds', {'g2'})
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<AddToGroupCubit, AddToGroupState>(
      'emits a safe generic message when adding fails for unknown reasons',
      build: () {
        stubFetch();
        when(() => repo.addMember(groupId: 'g1', userId: 'u1'))
            .thenThrow(Exception('socket closed'));
        return AddToGroupCubit(repo);
      },
      act: (cubit) async {
        await cubit.loadGroups('u1');
        await cubit.addToGroup('g1');
      },
      skip: 1,
      expect: () => [
        isA<AddToGroupState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );
  });
}
