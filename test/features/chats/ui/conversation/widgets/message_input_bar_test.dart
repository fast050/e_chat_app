import 'package:e_chat_app/features/chats/ui/conversation/widgets/message_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('send reports the trimmed text and clears the field',
      (tester) async {
    final sent = <String>[];
    await tester.pumpApp(MessageInputBar(onSend: sent.add));

    expect(find.text('Type a message ...'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '  Thanks a bunch!  ');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(sent, ['Thanks a bunch!']);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty);
  });

  testWidgets('send does nothing for a blank message', (tester) async {
    final sent = <String>[];
    await tester.pumpApp(MessageInputBar(onSend: sent.add));

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(sent, isEmpty);
  });

  testWidgets('the plus button reports an attach tap', (tester) async {
    var attachTaps = 0;
    await tester.pumpApp(
      MessageInputBar(onSend: (_) {}, onAttach: () => attachTaps++),
    );

    await tester.tap(find.byIcon(Icons.add));

    expect(attachTaps, 1);
  });
}
