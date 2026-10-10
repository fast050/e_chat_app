import 'package:e_chat_app/features/chats/ui/chat_media/widgets/chat_media_placeholder.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/widgets/date_section_label.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/widgets/document_tile.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Documents" tab: shared files, grouped by date.
class DocumentsView extends StatelessWidget {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMediaCubit, ChatMediaState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.documents != current.documents,
      builder: (context, state) {
        if (state.status == ChatMediaStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.documents.isEmpty) {
          return const ChatMediaPlaceholder(text: 'No documents yet');
        }
        return CustomScrollView(
          slivers: [
            for (final section in state.documents)
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
                      itemBuilder: (context, index) => _DocumentRow(
                        key: ValueKey(section.items[index].id),
                        document: section.items[index],
                      ),
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

// Only the tapped row rebuilds when its download finishes.
class _DocumentRow extends StatelessWidget {
  final DocumentItem document;

  const _DocumentRow({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatMediaCubit, ChatMediaState, bool>(
      selector: (state) => state.downloadedIds.contains(document.id),
      builder: (context, isDownloaded) => DocumentTile(
        name: document.name,
        sizeLabel: document.sizeLabel,
        extension: document.extension,
        isDownloaded: isDownloaded,
        onDownload: () =>
            context.read<ChatMediaCubit>().markDownloaded(document.id),
      ),
    );
  }
}
