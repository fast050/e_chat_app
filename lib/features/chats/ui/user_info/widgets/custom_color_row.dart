import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_row.dart';
import 'package:e_chat_app/features/chats/ui/user_info/widgets/chat_color_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Custom Color Chat" row: shows the current bubble color and opens the
/// color sheet. Needs a [ChatSettingsCubit] above it.
class CustomColorRow extends StatelessWidget {
  const CustomColorRow({super.key});

  Future<void> _pickColor(BuildContext context) async {
    final cubit = context.read<ChatSettingsCubit>();
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => ChatColorSheet(
        selectedColor: cubit.state.settings.bubbleColor,
      ),
    );
    if (picked == null) return;
    cubit.update(cubit.state.settings.copyWith(bubbleColor: picked));
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.primary;

    return SettingsRow(
      icon: Icons.palette_outlined,
      label: 'Custom Color Chat',
      onTap: () => _pickColor(context),
      trailing: BlocSelector<ChatSettingsCubit, ChatSettingsState, int?>(
        selector: (state) => state.settings.bubbleColor,
        builder: (context, bubbleColor) => Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: bubbleColor == null ? defaultColor : Color(bubbleColor),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
