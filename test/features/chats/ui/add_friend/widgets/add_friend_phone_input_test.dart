import 'package:e_chat_app/features/chats/ui/add_friend/widgets/add_friend_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the dial code and opens the country picker on tap',
      (tester) async {
    var countryTaps = 0;

    await tester.pumpApp(AddFriendPhoneInput(
      countryCode: 'GB',
      dialCode: '+44',
      onCountryTap: () => countryTaps++,
      onChanged: (_) {},
    ));

    expect(find.text('(+44)'), findsOneWidget);
    expect(find.text('Enter Phone Number'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

    expect(countryTaps, 1);
  });

  testWidgets('keeps only digits and reports the formatted number',
      (tester) async {
    final changes = <String>[];

    await tester.pumpApp(AddFriendPhoneInput(
      countryCode: 'GB',
      dialCode: '+44',
      onCountryTap: () {},
      onChanged: changes.add,
    ));

    await tester.enterText(find.byType(TextField), '50a9285');

    expect(changes.single.replaceAll(' ', ''), '509285');
  });
}
