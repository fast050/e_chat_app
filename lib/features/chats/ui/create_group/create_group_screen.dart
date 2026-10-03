import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_icon_button_blue50.dart';
import 'package:e_chat_app/core/widgets/gradient_button.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_state.dart';
import 'package:e_chat_app/features/chats/ui/create_group/widgets/add_members_sheet.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/friend_card.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/outlined_text_field.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateGroupCubit>();

    return Scaffold(
      body: Column(
        children: [
          const PageHeader(title: 'Create Group'),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 0),
                  sliver: SliverList.list(
                    children: [
                      const _FieldLabel('Name Group'),
                      SizedBox(height: 8.h),
                      OutlinedTextField(
                        hintText: 'Enter Name Group',
                        onChanged: cubit.updateName,
                      ),
                      SizedBox(height: 24.h),
                      const _FieldLabel('Members'),
                      SizedBox(height: 8.h),
                      const _AddMembersButton(),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(24.r),
                  sliver: const _MembersList(),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
            child: GradientButton(
              text: 'Create Group',
              onPressed: cubit.createGroup,
            ),
          ),
          const _CreateGroupListener(),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Text(
      text,
      style: textStyle.font16Medium.copyWith(color: colors.textPrimary),
    );
  }
}

class _AddMembersButton extends StatelessWidget {
  const _AddMembersButton();

  void _openPicker(BuildContext context) {
    final cubit = context.read<CreateGroupCubit>()..openMemberPicker();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      // The sheet is a separate route, outside this screen's BlocProvider.
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AddMembersSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: FilledIconButtonBlue50(
        icon: const Icon(Icons.add),
        text: 'Add Members',
        onPressed: () => _openPicker(context),
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  const _MembersList();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateGroupCubit, CreateGroupState, List<Friend>>(
      selector: (state) => state.members,
      builder: (context, members) => SliverList.separated(
        itemCount: members.length,
        separatorBuilder: (_, __) => SizedBox(height: 24.h),
        itemBuilder: (context, index) {
          final member = members[index];
          return FriendCard(
            key: ValueKey(member.id),
            name: member.name,
            phoneNumber: member.phoneNumber,
            avatarUrl: member.avatarUrl,
          );
        },
      ),
    );
  }
}

class _CreateGroupListener extends StatelessWidget {
  const _CreateGroupListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateGroupCubit, CreateGroupState>(
      listenWhen: (previous, current) =>
          previous.error != current.error ||
          (previous.status != current.status &&
              current.status == CreateGroupStatus.success),
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context)..clearSnackBars();
        if (state.status == CreateGroupStatus.success) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Group created')),
          );
          context.pop();
          return;
        }
        final error = state.error;
        if (error == null) return;
        messenger.showSnackBar(SnackBar(content: Text(error.message)));
      },
      child: const SizedBox.shrink(),
    );
  }
}
