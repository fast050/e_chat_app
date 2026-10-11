import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_settings_error_listener.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_row.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProtectedChatScreen extends StatelessWidget {
  final ConversationArgs args;

  const ProtectedChatScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PageHeader(title: args.name, isLight: true),
          const Expanded(child: _ProtectedChatBody()),
          const ChatSettingsErrorListener(),
        ],
      ),
    );
  }
}

class _ProtectedChatBody extends StatelessWidget {
  const _ProtectedChatBody();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return BlocSelector<ChatSettingsCubit, ChatSettingsState, bool>(
      selector: (state) => state.status == ChatSettingsStatus.loading,
      builder: (context, isLoading) {
        if (isLoading) return const Center(child: CircularProgressIndicator());
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          children: [
            SettingsRow(
              icon: Icons.shield_outlined,
              label: 'Protected Chat',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isProtected,
                onChanged: (settings, value) =>
                    settings.copyWith(isProtected: value),
              ),
            ),
            Divider(height: 16.h, thickness: 1, color: colors.inputBackground),
            SettingsRow(
              icon: Icons.password,
              label: 'PIN Security',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isPinEnabled,
                onChanged: (settings, value) =>
                    settings.copyWith(isPinEnabled: value),
              ),
            ),
            SettingsRow(
              icon: Icons.face_outlined,
              label: 'Face Recognition',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isFaceEnabled,
                onChanged: (settings, value) =>
                    settings.copyWith(isFaceEnabled: value),
              ),
            ),
            SettingsRow(
              icon: Icons.fingerprint,
              label: 'Fingerprint Security',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isFingerprintEnabled,
                onChanged: (settings, value) =>
                    settings.copyWith(isFingerprintEnabled: value),
              ),
            ),
          ],
        );
      },
    );
  }
}
