import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';

enum ChatMediaStatus { loading, success, failure }

/// Items shared on the days one heading ("Today", "Yesterday", ...) covers.
class DateSection<T> {
  final String label;
  final List<T> items;

  const DateSection({required this.label, required this.items});
}

class MediaItem {
  final String id;
  final String imageUrl;

  const MediaItem({required this.id, required this.imageUrl});
}

class DocumentItem {
  final String id;
  final String name;
  final String sizeLabel;
  final String extension;

  const DocumentItem({
    required this.id,
    required this.name,
    required this.sizeLabel,
    required this.extension,
  });
}

class ChatMediaState {
  final ChatMediaStatus status;
  // Sections and their items are newest first.
  final List<DateSection<MediaItem>> media;
  final List<DateSection<LinkAttachment>> links;
  final List<DateSection<DocumentItem>> documents;
  final int totalCount;
  final Set<String> downloadedIds;
  final UiError? error;

  const ChatMediaState({
    required this.status,
    required this.media,
    required this.links,
    required this.documents,
    required this.totalCount,
    required this.downloadedIds,
    this.error,
  });

  const ChatMediaState.initialState()
      : status = ChatMediaStatus.loading,
        media = const [],
        links = const [],
        documents = const [],
        totalCount = 0,
        downloadedIds = const {},
        error = null;

  ChatMediaState copyWith({
    ChatMediaStatus? status,
    List<DateSection<MediaItem>>? media,
    List<DateSection<LinkAttachment>>? links,
    List<DateSection<DocumentItem>>? documents,
    int? totalCount,
    Set<String>? downloadedIds,
    UiError? error,
  }) {
    return ChatMediaState(
      status: status ?? this.status,
      media: media ?? this.media,
      links: links ?? this.links,
      documents: documents ?? this.documents,
      totalCount: totalCount ?? this.totalCount,
      downloadedIds: downloadedIds ?? this.downloadedIds,
      error: error ?? this.error,
    );
  }
}
