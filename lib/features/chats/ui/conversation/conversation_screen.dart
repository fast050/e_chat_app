import 'dart:io';

import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_cubit.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_state.dart';
import 'package:e_chat_app/features/chats/ui/conversation/widgets/conversation_header.dart';
import 'package:e_chat_app/features/chats/ui/conversation/widgets/message_bubble.dart';
import 'package:e_chat_app/features/chats/ui/conversation/widgets/message_input_bar.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_settings_error_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationScreen extends StatelessWidget {
  final ConversationArgs args;

  const ConversationScreen({super.key, required this.args});

  Future<void> _openUserInfo(BuildContext context) async {
    final settingsCubit = context.read<ChatSettingsCubit>();
    await context.pushNamed(Routes.userInfo, arguments: args);
    // That screen has its own cubit; pick up the color/background it changed.
    settingsCubit.load(args.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ConversationHeader(
            name: args.name,
            phoneNumber: args.phoneNumber ?? '',
            avatarUrl: args.avatarUrl,
            onOpenInfo: () => _openUserInfo(context),
          ),
          const Expanded(child: _ConversationBackground(child: _MessagesBody())),
          MessageInputBar(
            onSend: context.read<ConversationCubit>().sendMessage,
          ),
          const _ConversationErrorListener(),
          const ChatSettingsErrorListener(),
        ],
      ),
    );
  }
}

// Takes the messages as [child] so they don't rebuild with the background.
class _ConversationBackground extends StatelessWidget {
  final Widget child;

  const _ConversationBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return BlocSelector<ChatSettingsCubit, ChatSettingsState, String?>(
      selector: (state) => state.settings.backgroundImagePath,
      builder: (context, path) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.inputBackground,
          image: path == null
              ? null
              : DecorationImage(
                  image: FileImage(File(path)),
                  fit: BoxFit.cover,
                ),
        ),
        child: child,
      ),
    );
  }
}

class _MessagesBody extends StatelessWidget {
  const _MessagesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.messages != current.messages,
      builder: (context, state) {
        if (state.status == ConversationStatus.initial ||
            state.status == ConversationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _MessagesList(messages: state.messages);
      },
    );
  }
}

class _MessagesList extends StatelessWidget {
  final List<MessageItem> messages;

  const _MessagesList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatSettingsCubit, ChatSettingsState, int?>(
      selector: (state) => state.settings.bubbleColor,
      builder: (context, bubbleColor) {
        final myBubbleColor = bubbleColor == null ? null : Color(bubbleColor);

        return ListView.separated(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          itemCount: messages.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final message = messages[index];
            return MessageBubble(
              key: ValueKey(message.id),
              text: message.text,
              timeLabel: message.timeLabel,
              isMine: message.isMine,
              imageUrl: message.imageUrl,
              bubbleColor: message.isMine ? myBubbleColor : null,
            );
          },
        );
      },
    );
  }
}

class _ConversationErrorListener extends StatelessWidget {
  const _ConversationErrorListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationCubit, ConversationState>(
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
