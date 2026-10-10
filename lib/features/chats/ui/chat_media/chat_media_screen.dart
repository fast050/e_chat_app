import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/documents_view.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/links_view.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/media_view.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMediaScreen extends StatelessWidget {
  final ConversationArgs args;

  const ChatMediaScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            PageHeader(title: args.name, isLight: true),
            const _MediaTabBar(),
            const Expanded(
              child: TabBarView(
                children: [MediaView(), LinksView(), DocumentsView()],
              ),
            ),
            const _ChatMediaErrorListener(),
          ],
        ),
      ),
    );
  }
}

class _MediaTabBar extends StatelessWidget {
  const _MediaTabBar();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: TabBar(
        labelStyle: textStyle.font16Bold,
        unselectedLabelStyle: textStyle.font16Bold,
        labelColor: colors.textPrimary,
        unselectedLabelColor: colors.textPrimary,
        indicatorColor: colors.textPrimary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Media'),
          Tab(text: 'Links'),
          Tab(text: 'Documents'),
        ],
      ),
    );
  }
}

class _ChatMediaErrorListener extends StatelessWidget {
  const _ChatMediaErrorListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatMediaCubit, ChatMediaState>(
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
