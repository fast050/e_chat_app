import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A [SettingsSwitch] bound to one flag of the chat settings: [value] reads
/// the flag, [onChanged] returns the settings with it changed. Needs a
/// [ChatSettingsCubit] above it.
class SettingsSwitchWidget extends StatelessWidget {
  final bool Function(ChatSettings settings) value;
  final ChatSettings Function(ChatSettings settings, bool value) onChanged;

  const SettingsSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatSettingsCubit, ChatSettingsState, bool>(
      selector: (state) => value(state.settings),
      builder: (context, isOn) => SettingsSwitch(
        value: isOn,
        onChanged: (newValue) {
          final cubit = context.read<ChatSettingsCubit>();
          cubit.update(onChanged(cubit.state.settings, newValue));
        },
      ),
    );
  }
}
