import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/create_group/create_group_screen.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('members ticked in the sheet are listed after tapping Add',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final friendsRepo = MockFriendsRepository();
    when(() => friendsRepo.fetchFriends()).thenAnswer((_) async => const [
          Friend(id: '1', name: 'David Wayne', phoneNumber: '+445092853022'),
          Friend(id: '4', name: 'Jean Dare', phoneNumber: '+445092856093'),
        ]);
    final cubit = CreateGroupCubit(friendsRepo, MockGroupsRepository())
      ..loadFriends();
    addTearDown(cubit.close);

    await tester.pumpApp(BlocProvider.value(
      value: cubit,
      child: const CreateGroupScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Jean Dare'), findsNothing);

    await tester.tap(find.text('Add Members'));
    await tester.pumpAndSettle();

    expect(find.text('Add members to group'), findsOneWidget);
    expect(find.text('David Wayne'), findsOneWidget);

    await tester.tap(find.text('Jean Dare'));
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Add members to group'), findsNothing);
    expect(find.text('Jean Dare'), findsOneWidget);
    expect(find.text('David Wayne'), findsNothing);
  });
}
