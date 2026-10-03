import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../helpers/mock_repositories.dart';

void main() {
  late MockFriendsRepository friendsRepo;
  late MockGroupsRepository groupsRepo;

  const david =
      Friend(id: '1', name: 'David Wayne', phoneNumber: '+445092853022');
  const jean = Friend(id: '4', name: 'Jean Dare', phoneNumber: '+445092856093');

  setUp(() {
    friendsRepo = MockFriendsRepository();
    groupsRepo = MockGroupsRepository();
    when(() => friendsRepo.fetchFriends()).thenAnswer((_) async => [
          david,
          jean,
        ]);
  });

  CreateGroupCubit buildCubit() => CreateGroupCubit(friendsRepo, groupsRepo);

  group('loadFriends', () {
    blocTest<CreateGroupCubit, CreateGroupState>(
      'emits the friends and shows them all in the picker',
      build: buildCubit,
      act: (cubit) => cubit.loadFriends(),
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.isLoadingFriends, 'loading', true),
        isA<CreateGroupState>()
            .having((s) => s.isLoadingFriends, 'loading', false)
            .having((s) => s.friends.length, 'friends', 2)
            .having((s) => s.pickerFriends.length, 'pickerFriends', 2),
      ],
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'emits the Supabase message on PostgrestException',
      build: () {
        when(() => friendsRepo.fetchFriends())
            .thenThrow(const PostgrestException(message: 'permission denied'));
        return buildCubit();
      },
      act: (cubit) => cubit.loadFriends(),
      skip: 1,
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.isLoadingFriends, 'loading', false)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'emits a safe generic message on unknown errors',
      build: () {
        when(() => friendsRepo.fetchFriends())
            .thenThrow(Exception('socket closed'));
        return buildCubit();
      },
      act: (cubit) => cubit.loadFriends(),
      skip: 1,
      expect: () => [
        isA<CreateGroupState>().having(
          (s) => s.error?.message,
          'error',
          'Something went wrong. Please try again.',
        ),
      ],
    );
  });

  blocTest<CreateGroupCubit, CreateGroupState>(
    'updateName stores the name',
    build: buildCubit,
    act: (cubit) => cubit.updateName('Game'),
    expect: () => [
      isA<CreateGroupState>().having((s) => s.name, 'name', 'Game'),
    ],
  );

  group('member picker', () {
    blocTest<CreateGroupCubit, CreateGroupState>(
      'searchFriends filters by name or phone, case-insensitive',
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadFriends();
        cubit.searchFriends('JEAN');
        cubit.searchFriends('3022');
        cubit.searchFriends(' ');
      },
      skip: 2,
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.pickerFriends.map((f) => f.id), 'ids', ['4']),
        isA<CreateGroupState>()
            .having((s) => s.pickerFriends.map((f) => f.id), 'ids', ['1']),
        isA<CreateGroupState>()
            .having((s) => s.pickerFriends.length, 'pickerFriends', 2),
      ],
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'toggleMember ticks then unticks a friend',
      build: buildCubit,
      act: (cubit) => cubit
        ..toggleMember('1')
        ..toggleMember('1'),
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.pickerSelectedIds, 'selected', {'1'}),
        isA<CreateGroupState>()
            .having((s) => s.pickerSelectedIds, 'selected', isEmpty),
      ],
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'confirmMembers turns the ticked friends into members',
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadFriends();
        cubit
          ..toggleMember('4')
          ..confirmMembers();
      },
      skip: 3,
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.members.map((f) => f.id), 'members', ['4']),
      ],
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'openMemberPicker drops unconfirmed ticks and a previous search',
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadFriends();
        cubit
          ..toggleMember('4')
          ..confirmMembers()
          ..toggleMember('1')
          ..searchFriends('jean')
          ..openMemberPicker();
      },
      skip: 6,
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.pickerSelectedIds, 'selected', {'4'}).having(
                (s) => s.pickerFriends.length, 'pickerFriends', 2),
      ],
    );
  });

  group('createGroup', () {
    Future<void> fillForm(CreateGroupCubit cubit) async {
      await cubit.loadFriends();
      cubit
        ..updateName('  Game  ')
        ..toggleMember('1')
        ..toggleMember('4')
        ..confirmMembers();
    }

    blocTest<CreateGroupCubit, CreateGroupState>(
      'sends the trimmed name and member ids, then emits success',
      build: () {
        when(() => groupsRepo.createGroup(
              name: any(named: 'name'),
              memberIds: any(named: 'memberIds'),
            )).thenAnswer((_) async {});
        return buildCubit();
      },
      act: (cubit) async {
        await fillForm(cubit);
        await cubit.createGroup();
      },
      skip: 6,
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.status, 'status', CreateGroupStatus.submitting),
        isA<CreateGroupState>()
            .having((s) => s.status, 'status', CreateGroupStatus.success),
      ],
      verify: (_) => verify(
        () => groupsRepo.createGroup(name: 'Game', memberIds: ['1', '4']),
      ).called(1),
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'asks for a name before calling the repository',
      build: buildCubit,
      act: (cubit) => cubit.createGroup(),
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.status, 'status', CreateGroupStatus.initial)
            .having((s) => s.error?.message, 'error', 'Enter a group name.'),
      ],
      verify: (_) => verifyNever(() => groupsRepo.createGroup(
            name: any(named: 'name'),
            memberIds: any(named: 'memberIds'),
          )),
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'asks for at least one member',
      build: buildCubit,
      act: (cubit) async {
        cubit.updateName('Game');
        await cubit.createGroup();
      },
      skip: 1,
      expect: () => [
        isA<CreateGroupState>().having(
          (s) => s.error?.message,
          'error',
          'Add at least one member.',
        ),
      ],
    );

    blocTest<CreateGroupCubit, CreateGroupState>(
      'emits failure with the Supabase message on PostgrestException',
      build: () {
        when(() => groupsRepo.createGroup(
                  name: any(named: 'name'),
                  memberIds: any(named: 'memberIds'),
                ))
            .thenThrow(const PostgrestException(message: 'permission denied'));
        return buildCubit();
      },
      act: (cubit) async {
        await fillForm(cubit);
        await cubit.createGroup();
      },
      skip: 7,
      expect: () => [
        isA<CreateGroupState>()
            .having((s) => s.status, 'status', CreateGroupStatus.failure)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );
  });
}
