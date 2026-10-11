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

  Color? fillOf(WidgetTester tester) {
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(MessageBubble),
        matching: find.byType(Container),
      ),
    );
    return (container.decoration! as BoxDecoration).color;
  }

  testWidgets('uses the custom chat color when one is given', (tester) async {
    await tester.pumpApp(
      const MessageBubble(
        text: 'Hi!',
        timeLabel: '10:10',
        isMine: true,
        bubbleColor: Color(0xFF9655FF),
      ),
    );

    expect(fillOf(tester), const Color(0xFF9655FF));
  });

  testWidgets('falls back to the theme color without a custom one',
      (tester) async {
    await tester.pumpApp(
      const MessageBubble(text: 'Hi!', timeLabel: '10:10', isMine: true),
    );

    final context = tester.element(find.byType(MessageBubble));
    expect(fillOf(tester), Theme.of(context).colorScheme.primary);
  });
}
