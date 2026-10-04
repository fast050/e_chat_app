import 'package:e_chat_app/features/chats/ui/conversation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('my message is right-aligned with a read tick', (tester) async {
    await tester.pumpApp(
      const MessageBubble(text: 'Hi!', timeLabel: '10:10', isMine: true),
    );

    expect(find.text('Hi!'), findsOneWidget);
    expect(find.text('10:10'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsOneWidget);
    expect(
      tester.widget<Align>(find.byType(Align).first).alignment,
      Alignment.centerRight,
    );
  });

  testWidgets('their message is left-aligned without a tick', (tester) async {
    await tester.pumpApp(
      const MessageBubble(
        text: "I'll text you when I arrive.",
        timeLabel: '10:11',
        isMine: false,
      ),
    );

    expect(find.text("I'll text you when I arrive."), findsOneWidget);
    expect(find.text('10:11'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsNothing);
    expect(
      tester.widget<Align>(find.byType(Align).first).alignment,
      Alignment.centerLeft,
    );
  });
}
