import 'dart:math' as math;

import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/logic/chats_cubit.dart';
import 'package:e_chat_app/features/chats/ui/logic/chats_state.dart';
import 'package:e_chat_app/features/chats/ui/widgets/chats_search_bar.dart';
import 'package:e_chat_app/features/chats/ui/widgets/header_glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Top of the title row. Design places it at y=51; never let it sit under a
/// taller status bar. The add menu is positioned relative to this too.
double chatsHeaderRowTop(BuildContext context) =>
    math.max(51.h, MediaQuery.paddingOf(context).top + 4.h);

class ChatsHeader extends StatelessWidget {
  const ChatsHeader({super.key});

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
      child: SizedBox(
        height: 43.h,
        child: BlocSelector<ChatsCubit, ChatsState, bool>(
          selector: (state) => state.isSearchOpen,
          builder: (context, isSearchOpen) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSearchOpen
                ? ChatsSearchBar(
                    key: const ValueKey('search'),
                    onChanged: context.read<ChatsCubit>().search,
                    onClose: context.read<ChatsCubit>().closeSearch,
                  )
                : const _TitleRow(key: ValueKey('title')),
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _HeaderLogo(),
        const Spacer(),
        GestureDetector(
          onTap: context.read<ChatsCubit>().openSearch,
          child: SvgPicture.asset(
            'assets/svgs/search.svg',
            width: 24.r,
            height: 24.r,
          ),
        ),
        SizedBox(width: 16.w),
        const _AddButton(),
      ],
    );
  }
}

// Open menu = plus rotated 45° (reads as an X) on a highlighted button.
class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatsCubit, ChatsState, bool>(
      selector: (state) => state.isAddMenuOpen,
      builder: (context, isOpen) => HeaderGlassButton(
        size: 36.r,
        isHighlighted: isOpen,
        onTap: context.read<ChatsCubit>().toggleAddMenu,
        child: AnimatedRotation(
          turns: isOpen ? -1 / 8 : 0,
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            'assets/svgs/plus.svg',
            width: 36.r,
            height: 36.r,
          ),
        ),
      ),
    );
  }
}

// Offsets mirror the Figma "Logo E-Chat" instance (92.26 x 32); the icon
// intentionally bleeds past its box to leave room for its drop shadow.
class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92.26.r,
      height: 32.r,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -4.16.r,
            top: -0.83.r,
            width: 36.16.r,
            height: 30.96.r,
            child: SvgPicture.asset(
              'assets/svgs/header_logo_icon.svg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 42.r,
            top: 9.14.r,
            width: 50.44.r,
            height: 12.65.r,
            child: SvgPicture.asset(
              'assets/svgs/header_logo_wordmark.svg',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
