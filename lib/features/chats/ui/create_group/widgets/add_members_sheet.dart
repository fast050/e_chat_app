import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/core/widgets/filled_text_button_blue50.dart';
import 'package:e_chat_app/core/widgets/gradient_button.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/friend_card.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Content of the "Add members to group" bottom sheet. Needs a
/// [CreateGroupCubit] above it.
class AddMembersSheet extends StatelessWidget {
  const AddMembersSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final cubit = context.read<CreateGroupCubit>();

    return Padding(
      // Keeps the buttons above the keyboard while searching.
      padding: EdgeInsets.fromLTRB(
        24.w,
        0,
        24.w,
        MediaQuery.viewInsetsOf(context).bottom + 24.h,
      ),
      child: Column(
        children: [
          Text(
            'Add members to group',
            style: textStyle.font20Medium.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: 16.h),
          OutlinedTextField(
            hintText: 'Search',
            onChanged: cubit.searchFriends,
            prefix: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 12.w),
              child: SvgPicture.asset(
                'assets/svgs/search.svg',
                width: 24.r,
                height: 24.r,
                colorFilter:
                    ColorFilter.mode(colors.textSecondary, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const Expanded(child: _PickerBody()),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60.h,
                  child: FilledTextButtonBlue50(
                    text: 'Cancel',
                    onPressed: context.pop,
                  ),
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: GradientButton(
                  text: 'Add',
                  onPressed: () {
                    cubit.confirmMembers();
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerBody extends StatelessWidget {
  const _PickerBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateGroupCubit, CreateGroupState>(
      buildWhen: (previous, current) =>
          previous.isLoadingFriends != current.isLoadingFriends ||
          previous.pickerFriends != current.pickerFriends ||
          previous.pickerSelectedIds != current.pickerSelectedIds,
      builder: (context, state) {
        if (state.isLoadingFriends) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.pickerFriends.isEmpty) {
          return _EmptyPicker(hasFriends: state.friends.isNotEmpty);
        }
        return _PickerList(
          friends: state.pickerFriends,
          selectedIds: state.pickerSelectedIds,
        );
      },
    );
  }
}

class _PickerList extends StatelessWidget {
  final List<Friend> friends;
  final Set<String> selectedIds;

  const _PickerList({required this.friends, required this.selectedIds});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return ListView.separated(
      itemCount: friends.length,
      separatorBuilder: (_, __) => SizedBox(height: 24.h),
      itemBuilder: (context, index) {
        final friend = friends[index];
        final isSelected = selectedIds.contains(friend.id);
        return FriendCard(
          key: ValueKey(friend.id),
          name: friend.name,
          phoneNumber: friend.phoneNumber,
          avatarUrl: friend.avatarUrl,
          onTap: () => context.read<CreateGroupCubit>().toggleMember(friend.id),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 24.r,
            color: isSelected ? colors.badgeBackground : colors.cardBackground,
          ),
        );
      },
    );
  }
}

class _EmptyPicker extends StatelessWidget {
  final bool hasFriends;

  const _EmptyPicker({required this.hasFriends});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Text(
        hasFriends ? 'No friends found' : 'No friends yet',
        style: textStyle.font16Medium.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
