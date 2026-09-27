import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppNavTab {
  chats('Chats', 'assets/svgs/nav_chats.svg'),
  groups('Groups', 'assets/svgs/nav_groups.svg'),
  profile('Profile', 'assets/svgs/nav_profile.svg'),
  more('More', 'assets/svgs/nav_more.svg');

  const AppNavTab(this.label, this.iconAsset);

  final String label;
  final String iconAsset;
}

class AppBottomNavBar extends StatelessWidget {
  final AppNavTab activeTab;
  final void Function(AppNavTab tab)? onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.activeTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Container(
      height: 100.h,
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: colors.navBarBackground,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0D0A2C),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          for (final tab in AppNavTab.values)
            Expanded(
              child: _NavItem(
                tab: tab,
                isActive: tab == activeTab,
                onTap: onTabSelected == null ? null : () => onTabSelected!(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final AppNavTab tab;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({required this.tab, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final contentColor = isActive ? colors.textOnAccent : colors.textSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 76.w,
          height: 70.h,
          margin: EdgeInsets.only(top: 10.h),
          decoration: isActive
              ? BoxDecoration(
                  gradient: AppGradients.navActiveGradient,
                  borderRadius: BorderRadius.circular(12.r),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                tab.iconAsset,
                width: 24.r,
                height: 24.r,
                // Active icons keep their original colors (e.g. gradient dots on Chats).
                colorFilter: isActive
                    ? null
                    : ColorFilter.mode(contentColor, BlendMode.srcIn),
              ),
              SizedBox(height: 8.h),
              Text(
                tab.label,
                style: textStyle.font12Medium.copyWith(color: contentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
