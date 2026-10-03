import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/bottom_nav/ui/app_bottom_nav_bar.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/logic/chats_cubit.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/logic/chats_state.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/widgets/chat_list_tile.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/widgets/chats_add_menu.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/widgets/chats_header.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/header_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CloseOverlaysOnBack(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                ChatsHeader(),
                Expanded(child: _ChatsBody()),
                _ChatsErrorListener(),
              ],
            ),
            _AddMenuOverlay(),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(activeTab: AppNavTab.chats),
      ),
    );
  }
}

// Back button closes an open add menu / search before leaving the screen.
class _CloseOverlaysOnBack extends StatelessWidget {
  final Widget child;

  const _CloseOverlaysOnBack({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatsCubit, ChatsState, bool>(
      selector: (state) => state.isAddMenuOpen || state.isSearchOpen,
      builder: (context, hasOverlay) => PopScope(
        canPop: !hasOverlay,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          final cubit = context.read<ChatsCubit>();
          if (cubit.state.isAddMenuOpen) {
            cubit.closeAddMenu();
          } else {
            cubit.closeSearch();
          }
        },
        child: child,
      ),
    );
  }
}

class _AddMenuOverlay extends StatelessWidget {
  const _AddMenuOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatsCubit, ChatsState, bool>(
      selector: (state) => state.isAddMenuOpen,
      builder: (context, isOpen) {
        if (!isOpen) return const SizedBox.shrink();
        final cubit = context.read<ChatsCubit>();
        return Stack(
          children: [
            // Tap anywhere outside the menu to close it (includes the X button).
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: cubit.closeAddMenu,
              ),
            ),
            Positioned(
              top: chatsHeaderRowTop(context) + 51.h,
              right: 24.w,
              child: ChatsAddMenu(
                onAddFriend: () {
                  cubit.closeAddMenu();
                  context.pushNamed(Routes.addFriend);
                },
                onCreateGroup: () {
                  cubit.closeAddMenu();
                  context.pushNamed(Routes.createGroup);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChatsBody extends StatelessWidget {
  const _ChatsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.chats != current.chats ||
          previous.searchQuery.isEmpty != current.searchQuery.isEmpty,
      builder: (context, state) {
        if (state.status == ChatsStatus.initial ||
            state.status == ChatsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.chats.isEmpty) {
          return _EmptyChats(isSearching: state.searchQuery.isNotEmpty);
        }
        return _ChatsList(chats: state.chats);
      },
    );
  }
}

class _ChatsList extends StatelessWidget {
  final List<ChatPreview> chats;

  const _ChatsList({required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
      itemCount: chats.length,
      separatorBuilder: (_, __) => SizedBox(height: 24.h),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatListTile(
          key: ValueKey(chat.id),
          name: chat.name,
          avatarUrl: chat.avatarUrl,
          lastMessage: chat.lastMessage,
          timeLabel: chat.timeLabel,
          unreadCount: chat.unreadCount,
        );
      },
    );
  }
}

class _EmptyChats extends StatelessWidget {
  final bool isSearching;

  const _EmptyChats({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Text(
        isSearching ? 'No chats found' : 'No chats yet',
        style: textStyle.font16Medium.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _ChatsErrorListener extends StatelessWidget {
  const _ChatsErrorListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsCubit, ChatsState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        final error = state.error;
        if (error == null) return;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      },
      child: const SizedBox.shrink(),
    );
  }
}
