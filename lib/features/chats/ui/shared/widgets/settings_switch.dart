import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The pill switch of the settings lists, in the app colors.
class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return SizedBox(
      height: 28.h,
      child: FittedBox(
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: colors.badgeBackground,
          inactiveTrackColor: colors.cardBackground,
          thumbColor: colors.textOnAccent,
        ),
      ),
    );
  }
}
