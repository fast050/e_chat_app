import 'package:e_chat_app/features/chats/ui/shared/widgets/header_shell.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the title on the blue header by default', (tester) async {
    await tester.pumpApp(const PageHeader(title: 'Add Friend'));

    expect(find.text('Add Friend'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(HeaderShell), findsOneWidget);
  });

  testWidgets('the light header skips the blue shell and shows the trailing',
      (tester) async {
    await tester.pumpApp(const PageHeader(
      title: 'David Wayne',
      isLight: true,
      trailing: Icon(Icons.more_horiz),
    ));

    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    expect(find.byType(HeaderShell), findsNothing);
  });
}
