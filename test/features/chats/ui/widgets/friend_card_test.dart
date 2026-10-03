import 'package:e_chat_app/features/chats/ui/widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows name, phone number and initials without an avatar url',
      (tester) async {
    await tester.pumpApp(const FriendCard(
      name: 'David Wayne',
      phoneNumber: '+445092853022',
    ));

    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('+445092853022'), findsOneWidget);
    expect(find.text('DW'), findsOneWidget);
  });

  testWidgets('shows the trailing widget and reports taps', (tester) async {
    var taps = 0;

    await tester.pumpApp(FriendCard(
      name: 'Jean Dare',
      phoneNumber: '+445092856093',
      trailing: const Icon(Icons.check_circle),
      onTap: () => taps++,
    ));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.tap(find.text('Jean Dare'));

    expect(taps, 1);
  });
}
