import 'dart:math' as math;

import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Top of the title row. Design places it at y=51; never let it sit under a
/// taller status bar. The add menu is positioned relative to this too.
double chatsHeaderRowTop(BuildContext context) =>
    math.max(51.h, MediaQuery.paddingOf(context).top + 4.h);

/// Blue header background shared by the chats list and its pushed screens;
/// [child] is the 43-high title row.
class HeaderShell extends StatelessWidget {
  final Widget child;

  const HeaderShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final rowTop = chatsHeaderRowTop(context);
    final radius = BorderRadius.only(bottomRight: Radius.circular(50.r));

    return Container(
      height: rowTop + 59.h,
      decoration: BoxDecoration(
        color: colors.headerBackground,
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        gradient: AppGradients.headerSheenGradient,
        borderRadius: radius,
      ),
      padding: EdgeInsets.only(top: rowTop, left: 24.w, right: 24.w),
      alignment: Alignment.topCenter,
      child: SizedBox(height: 43.h, child: child),
    );
  }
}
