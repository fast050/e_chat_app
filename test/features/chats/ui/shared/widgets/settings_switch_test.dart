import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the given value', (tester) async {
    await tester.pumpApp(SettingsSwitch(value: true, onChanged: (_) {}));

    expect(
      tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch)).value,
      isTrue,
    );
  });

  testWidgets('reports the opposite value when tapped', (tester) async {
    bool? changedTo;

    await tester.pumpApp(SettingsSwitch(
      value: false,
      onChanged: (value) => changedTo = value,
    ));
    await tester.tap(find.byType(SettingsSwitch));

    expect(changedTo, isTrue);
  });
}
