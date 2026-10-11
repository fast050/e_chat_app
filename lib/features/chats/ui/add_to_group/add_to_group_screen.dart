import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_state.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/widgets/group_tile.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddToGroupScreen extends StatelessWidget {
  final ConversationArgs args;

  const AddToGroupScreen({super.key, required this.args});

  Future<void> _openCreateGroup(BuildContext context) async {
    final cubit = context.read<AddToGroupCubit>();
    await context.pushNamed(Routes.createGroup);
    // The sample chat ids double as the other user's id.
    cubit.loadGroups(args.chatId);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Scaffold(
      body: Column(
        children: [
          PageHeader(title: args.name, isLight: true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add to Groups',
                    style: textStyle.font14Regular
                        .copyWith(color: colors.textTertiary),
                  ),
                  SizedBox(height: 8.h),
                  SearchTextField(
                    onChanged: context.read<AddToGroupCubit>().search,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 56.h,
                    child: FilledIconButtonBlue50(
                      icon: const Icon(Icons.add),
                      text: 'Create new group',
                      onPressed: () => _openCreateGroup(context),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  const Expanded(child: _GroupsBody()),
                ],
              ),
            ),
          ),
          const _AddToGroupErrorListener(),
        ],
      ),
    );
  }
}

class _GroupsBody extends StatelessWidget {
  const _GroupsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToGroupCubit, AddToGroupState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.groups != current.groups ||
          previous.addedIds != current.addedIds,
      builder: (context, state) {
        if (state.status == AddToGroupStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.groups.isEmpty) return const _NoGroups();
        return ListView.separated(
          padding: EdgeInsets.only(bottom: 24.h),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: state.groups.length,
          separatorBuilder: (_, __) => SizedBox(height: 24.h),
          itemBuilder: (context, index) {
            final group = state.groups[index];
            return GroupTile(
              key: ValueKey(group.id),
              name: group.name,
              subtitle: group.lastMessage,
              avatarUrls: group.avatarUrls,
              isAdded: state.addedIds.contains(group.id),
              onAdd: () =>
                  context.read<AddToGroupCubit>().addToGroup(group.id),
            );
          },
        );
      },
    );
  }
}

class _NoGroups extends StatelessWidget {
  const _NoGroups();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Text(
        'No groups found',
        style: textStyle.font16Medium.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _AddToGroupErrorListener extends StatelessWidget {
  const _AddToGroupErrorListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToGroupCubit, AddToGroupState>(
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
