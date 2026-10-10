import 'dart:io';

import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

enum _BackgroundAction { change, remove }

/// "Custom Background Chat" row: shows the current background and lets the
/// user pick one from the gallery or remove it. Needs a [ChatSettingsCubit]
/// above it.
class CustomBackgroundRow extends StatelessWidget {
  const CustomBackgroundRow({super.key});

  Future<void> _onTap(BuildContext context) async {
    final cubit = context.read<ChatSettingsCubit>();
    if (cubit.state.settings.backgroundImagePath == null) {
      return _pickFromGallery(cubit);
    }

    final action = await showModalBottomSheet<_BackgroundAction>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => const _BackgroundActionsSheet(),
    );
    if (action == _BackgroundAction.change) return _pickFromGallery(cubit);
    if (action == _BackgroundAction.remove) {
      cubit.update(cubit.state.settings.copyWith(clearBackgroundImage: true));
    }
  }

  Future<void> _pickFromGallery(ChatSettingsCubit cubit) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null || cubit.isClosed) return;
    cubit.update(
      cubit.state.settings.copyWith(backgroundImagePath: image.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return SettingsRow(
      icon: Icons.wallpaper_outlined,
      label: 'Custom Background Chat',
      onTap: () => _onTap(context),
      trailing: BlocSelector<ChatSettingsCubit, ChatSettingsState, String?>(
        selector: (state) => state.settings.backgroundImagePath,
        builder: (context, path) => ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: path == null
              ? Container(
                  width: 24.r,
                  height: 24.r,
                  color: colors.inputBackground,
                )
              : Image.file(
                  File(path),
                  width: 24.r,
                  height: 24.r,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class _BackgroundActionsSheet extends StatelessWidget {
  const _BackgroundActionsSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsRow(
            icon: Icons.photo_library_outlined,
            label: 'Choose from gallery',
            onTap: () => Navigator.of(context).pop(_BackgroundAction.change),
          ),
          SettingsRow(
            icon: Icons.delete_outline,
            label: 'Remove background',
            onTap: () => Navigator.of(context).pop(_BackgroundAction.remove),
          ),
        ],
      ),
    );
  }
}
