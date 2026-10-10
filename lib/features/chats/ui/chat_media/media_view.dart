import 'package:e_chat_app/features/chats/ui/chat_media/widgets/chat_media_placeholder.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/widgets/date_section_label.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Media" tab: shared pictures in a grid, grouped by date.
class MediaView extends StatelessWidget {
  const MediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMediaCubit, ChatMediaState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.media != current.media,
      builder: (context, state) {
        if (state.status == ChatMediaStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.media.isEmpty) {
          return const ChatMediaPlaceholder(text: 'No media yet');
        }
        return CustomScrollView(
          slivers: [
            for (final section in state.media)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: DateSectionLabel(label: section.label),
                    ),
                    SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8.r,
                        crossAxisSpacing: 8.r,
                      ),
                      itemCount: section.items.length,
                      itemBuilder: (context, index) {
                        final item = section.items[index];
                        return ChatImage(
                          key: ValueKey(item.id),
                          url: item.imageUrl,
                          radius: 8.r,
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
