import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_settings_error_listener.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_row.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_switch_widget.dart';
import 'package:e_chat_app/features/chats/ui/user_info/widgets/custom_background_row.dart';
import 'package:e_chat_app/features/chats/ui/user_info/widgets/custom_color_row.dart';
import 'package:e_chat_app/features/chats/ui/user_info/widgets/user_info_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoScreen extends StatelessWidget {
  final ConversationArgs args;

  const UserInfoScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Scaffold(
      body: Column(
        children: [
          const PageHeader(isLight: true),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              children: [
                UserInfoProfile(
                  name: args.name,
                  phoneNumber: args.phoneNumber,
                  avatarUrl: args.avatarUrl,
                ),
                Divider(
                  height: 32.h,
                  thickness: 1,
                  color: colors.inputBackground,
                ),
                _SettingsRows(args: args),
              ],
            ),
          ),
          const ChatSettingsErrorListener(),
        ],
      ),
    );
  }
}

class _SettingsRows extends StatelessWidget {
  final ConversationArgs args;

  const _SettingsRows({required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatSettingsCubit, ChatSettingsState, bool>(
      selector: (state) => state.status == ChatSettingsStatus.loading,
      builder: (context, isLoading) {
        if (isLoading) {
          return Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        return Column(
          children: [
            _MediaRow(args: args),
            SettingsRow(
              icon: Icons.volume_off_outlined,
              label: 'Mute Notification',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isMuted,
                onChanged: (settings, value) =>
                    settings.copyWith(isMuted: value),
              ),
            ),
            _ProtectedChatRow(args: args),
            SettingsRow(
              icon: Icons.visibility_off_outlined,
              label: 'Hide Chat',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isHidden,
                onChanged: (settings, value) =>
                    settings.copyWith(isHidden: value),
              ),
            ),
            SettingsRow(
              icon: Icons.visibility_off_outlined,
              label: 'Hide Chat History',
              trailing: SettingsSwitchWidget(
                value: (settings) => settings.isHistoryHidden,
                onChanged: (settings, value) =>
                    settings.copyWith(isHistoryHidden: value),
              ),
            ),
            SettingsRow(
              icon: Icons.groups_outlined,
              label: 'Add To Group',
              trailing: const _Chevron(),
              onTap: () =>
                  context.pushNamed(Routes.addToGroup, arguments: args),
            ),
            const CustomColorRow(),
            const CustomBackgroundRow(),
          ],
        );
      },
    );
  }
}

class _MediaRow extends StatelessWidget {
  final ConversationArgs args;

  const _MediaRow({required this.args});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return SettingsRow(
      icon: Icons.photo_library_outlined,
      label: 'Media, Links & Documents',
      onTap: () => context.pushNamed(Routes.chatMedia, arguments: args),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocSelector<ChatMediaCubit, ChatMediaState, int>(
            selector: (state) => state.totalCount,
            builder: (context, totalCount) => Text(
              '$totalCount',
              style: textStyle.font16Bold.copyWith(color: colors.textPrimary),
            ),
          ),
          SizedBox(width: 16.w),
          const _Chevron(),
        ],
      ),
    );
  }
}

class _ProtectedChatRow extends StatelessWidget {
  final ConversationArgs args;

  const _ProtectedChatRow({required this.args});

  Future<void> _openProtectedChat(BuildContext context) async {
    final cubit = context.read<ChatSettingsCubit>();
    await context.pushNamed(Routes.protectedChat, arguments: args);
    // That screen has its own cubit; pick up what it changed.
    cubit.load(args.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: Icons.shield_outlined,
      label: 'Protected Chat',
      onTap: () => _openProtectedChat(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsSwitchWidget(
            value: (settings) => settings.isProtected,
            onChanged: (settings, value) =>
                settings.copyWith(isProtected: value),
          ),
          SizedBox(width: 16.w),
          const _Chevron(),
        ],
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Icon(Icons.chevron_right, size: 24.r, color: colors.textPrimary);
  }
}
