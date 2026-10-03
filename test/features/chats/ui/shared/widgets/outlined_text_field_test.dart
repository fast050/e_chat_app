import 'package:e_chat_app/features/chats/ui/shared/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the hint and prefix, and reports typed text',
      (tester) async {
    final changes = <String>[];

    await tester.pumpApp(OutlinedTextField(
      hintText: 'Enter Name Group',
      prefix: const Icon(Icons.search),
      onChanged: changes.add,
    ));

    expect(find.text('Enter Name Group'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Game');

    expect(changes, ['Game']);
  });
}
