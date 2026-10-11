import 'package:e_chat_app/features/chats/ui/add_to_group/widgets/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the group and reports a tap on Add', (tester) async {
    var adds = 0;

    await tester.pumpApp(GroupTile(
      name: 'Diamond Team',
      subtitle: 'Thanks a bunch!',
      avatarUrls: const [],
      isAdded: false,
      onAdd: () => adds++,
    ));

    expect(find.text('Diamond Team'), findsOneWidget);
    expect(find.text('Thanks a bunch!'), findsOneWidget);
    expect(find.text('DT'), findsOneWidget);

    await tester.tap(find.text('Add'));

    expect(adds, 1);
  });

  testWidgets('shows a disabled Added button for a joined group',
      (tester) async {
    var adds = 0;

    await tester.pumpApp(GroupTile(
      name: 'Diamond Team',
      subtitle: 'Thanks a bunch!',
      avatarUrls: const [],
      isAdded: true,
      onAdd: () => adds++,
    ));

    expect(find.text('Add'), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.tap(find.text('Added'));

    expect(adds, 0);
  });
}
