import 'package:e_chat_app/features/chats/ui/chats_list/logic/chats_cubit.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/logic/chats_state.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/widgets/chats_search_bar.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_glass_button.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsHeader extends StatelessWidget {
  const ChatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderShell(
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
