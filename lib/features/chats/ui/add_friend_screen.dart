import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/logic/add_friend_cubit.dart';
import 'package:e_chat_app/features/chats/ui/logic/add_friend_state.dart';
import 'package:e_chat_app/features/chats/ui/widgets/add_friend_phone_input_widget.dart';
import 'package:e_chat_app/features/chats/ui/widgets/friend_card.dart';
import 'package:e_chat_app/features/chats/ui/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageHeader(title: 'Add Friend'),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 0),
            child: const AddFriendPhoneInputWidget(),
          ),
          const Expanded(child: _AddFriendBody()),
          const _AddFriendErrorListener(),
        ],
      ),
    );
  }
}

class _AddFriendBody extends StatelessWidget {
  const _AddFriendBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFriendCubit, AddFriendState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.results != current.results ||
          previous.addedIds != current.addedIds,
      builder: (context, state) {
        if (state.results.isNotEmpty) {
          return _ResultsList(
            results: state.results,
            addedIds: state.addedIds,
          );
        }
        return switch (state.status) {
          AddFriendStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          AddFriendStatus.success => const _NoResults(),
          AddFriendStatus.initial ||
          AddFriendStatus.failure =>
            const _SearchPlaceholder(),
        };
      },
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<Friend> results;
  final Set<String> addedIds;

  const _ResultsList({required this.results, required this.addedIds});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(24.r),
      itemCount: results.length,
      separatorBuilder: (_, __) => SizedBox(height: 24.h),
      itemBuilder: (context, index) {
        final user = results[index];
        return FriendCard(
          key: ValueKey(user.id),
          name: user.name,
          phoneNumber: user.phoneNumber,
          avatarUrl: user.avatarUrl,
          trailing: _AddButton(
            isAdded: addedIds.contains(user.id),
            onTap: () => context.read<AddFriendCubit>().addFriend(user.id),
          ),
        );
      },
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onTap;

  const _AddButton({required this.isAdded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return IconButton(
      onPressed: isAdded ? null : onTap,
      tooltip: isAdded ? 'Added' : 'Add friend',
      color: colors.badgeBackground,
      disabledColor: colors.textSecondary,
      icon: Icon(isAdded ? Icons.check : Icons.person_add_alt_1_outlined),
    );
  }
}

class _SearchPlaceholder extends StatelessWidget {
  const _SearchPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Icon(
        Icons.person_search_outlined,
        size: 160.r,
        color: colors.cardBackground.withValues(alpha: .4),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Text(
        'No users found',
        style: textStyle.font16Medium.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _AddFriendErrorListener extends StatelessWidget {
  const _AddFriendErrorListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFriendCubit, AddFriendState>(
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
