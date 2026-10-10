import 'package:e_chat_app/features/chats/ui/chat_media/widgets/chat_media_placeholder.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/widgets/date_section_label.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/widgets/link_card.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Links" tab: shared links, grouped by date.
class LinksView extends StatelessWidget {
  const LinksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMediaCubit, ChatMediaState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.links != current.links,
      builder: (context, state) {
        if (state.status == ChatMediaStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.links.isEmpty) {
          return const ChatMediaPlaceholder(text: 'No links yet');
        }
        return CustomScrollView(
          slivers: [
            for (final section in state.links)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: DateSectionLabel(label: section.label),
                    ),
                    SliverList.separated(
                      itemCount: section.items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final link = section.items[index];
                        return LinkCard(
                          key: ValueKey(link.id),
                          title: link.title,
                          url: link.url,
                          thumbnailUrl: link.thumbnailUrl,
                        );
                      },
                    ),
                  ],
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        );
      },
    );
  }
}
