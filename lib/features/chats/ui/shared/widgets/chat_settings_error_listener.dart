import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows chat settings errors in a snackbar. Needs a [ChatSettingsCubit]
/// above it.
class ChatSettingsErrorListener extends StatelessWidget {
  const ChatSettingsErrorListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatSettingsCubit, ChatSettingsState>(
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
