import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the icon, label and trailing widget', (tester) async {
    await tester.pumpApp(const SettingsRow(
      icon: Icons.group_outlined,
      label: 'Add To Group',
      trailing: Icon(Icons.chevron_right),
    ));

    expect(find.byIcon(Icons.group_outlined), findsOneWidget);
    expect(find.text('Add To Group'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('reports taps', (tester) async {
    var taps = 0;

    await tester.pumpApp(SettingsRow(
      icon: Icons.group_outlined,
      label: 'Add To Group',
      onTap: () => taps++,
    ));
    await tester.tap(find.text('Add To Group'));

    expect(taps, 1);
  });
}
