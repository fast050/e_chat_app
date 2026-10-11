import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/chats/domain/entities/group.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/add_to_group_screen.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/widgets/group_tile.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockGroupsRepository repo;
  const groups = [
    Group(id: 'g1', name: 'Diamond Team', memberIds: ['2']),
    Group(id: 'g2', name: 'Delivery', memberIds: ['1']),
  ];

  setUp(() => repo = MockGroupsRepository());

  Future<void> pumpScreen(
    WidgetTester tester, {
    RouteFactory? onGenerateRoute,
  }) async {
    // Wider than the design: the test font draws every glyph as a full square,
    // so "Create new group" needs about twice the room it takes in Roboto.
    tester.view.physicalSize = const Size(600, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = AddToGroupCubit(repo);
    addTearDown(cubit.close);
    cubit.loadGroups('1');

    await tester.pumpApp(
      BlocProvider.value(
        value: cubit,
        child: const AddToGroupScreen(
          args: ConversationArgs(chatId: '1', name: 'David Wayne'),
        ),
      ),
      onGenerateRoute: onGenerateRoute,
    );
    await tester.pumpAndSettle();
  }

  GroupTile tile(WidgetTester tester, String name) => tester.widget<GroupTile>(
        find.ancestor(of: find.text(name), matching: find.byType(GroupTile)),
      );

  testWidgets('lists the groups, filters them and adds the user to one',
      (tester) async {
    when(() => repo.fetchGroups()).thenAnswer((_) async => groups);
    when(() => repo.addMember(groupId: 'g1', userId: '1'))
        .thenAnswer((_) async {});

    await pumpScreen(tester);

    expect(find.text('Add to Groups'), findsOneWidget);
    expect(tile(tester, 'Diamond Team').isAdded, isFalse);
    expect(tile(tester, 'Delivery').isAdded, isTrue);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    verify(() => repo.addMember(groupId: 'g1', userId: '1')).called(1);
    expect(tile(tester, 'Diamond Team').isAdded, isTrue);

    await tester.enterText(find.byType(TextField), 'deliv');
    await tester.pumpAndSettle();

    expect(find.text('Diamond Team'), findsNothing);
    expect(find.text('Delivery'), findsOneWidget);
  });

  testWidgets('shows a group created from "Create new group" after returning',
      (tester) async {
    var fetches = 0;
    when(() => repo.fetchGroups()).thenAnswer((_) async {
      if (++fetches == 1) return groups;
      return const [
        Group(id: 'g3', name: 'Book Club', memberIds: []),
        ...groups,
      ];
    });

    await pumpScreen(
      tester,
      onGenerateRoute: (settings) {
        if (settings.name != Routes.createGroup) return null;
        return MaterialPageRoute<void>(
          builder: (_) => const Text('create group'),
        );
      },
    );

    expect(find.text('Book Club'), findsNothing);

    await tester.tap(find.text('Create new group'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.text('create group'))).pop();
    await tester.pumpAndSettle();

    expect(find.text('Book Club'), findsOneWidget);
  });
}
