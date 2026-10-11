import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/repo/attachments_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/messages_repository.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/chat_time_format.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/file_format.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMediaCubit extends Cubit<ChatMediaState> {
  final MessagesRepository _messages;
  final AttachmentsRepository _attachments;
  final DateTime Function() _now;

  ChatMediaCubit(
    this._messages,
    this._attachments, {
    DateTime Function() now = DateTime.now,
  })  : _now = now,
        super(const ChatMediaState.initialState());

  Future<void> load(String chatId) async {
    try {
      final messages = await _messages.fetchMessages(chatId);
      final links = await _attachments.fetchLinks(chatId);
      final documents = await _attachments.fetchDocuments(chatId);
      if (isClosed) return;

      final now = _now();
      final images =
          messages.where((message) => message.imageUrl != null).toList();
      emit(state.copyWith(
        status: ChatMediaStatus.success,
        media: _sections(
          images,
          now: now,
          dateOf: (message) => message.createdAt,
          toItem: (message) =>
              MediaItem(id: message.id, imageUrl: message.imageUrl!),
        ),
        links: _sections(
          links,
          now: now,
          dateOf: (link) => link.createdAt,
          toItem: (link) => link,
        ),
        documents: _sections(
          documents,
          now: now,
          dateOf: (document) => document.createdAt,
          toItem: (document) => DocumentItem(
            id: document.id,
            name: fileNameWithoutExtension(document.name),
            sizeLabel: formatFileSize(document.sizeBytes),
            extension: fileExtension(document.name),
          ),
        ),
        totalCount: images.length + links.length + documents.length,
      ));
    } on AuthException catch (e) {
      _emitError(e.message);
    } on PostgrestException catch (e) {
      _emitError(e.message);
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  void markDownloaded(String documentId) {
    emit(state.copyWith(
      downloadedIds: {...state.downloadedIds, documentId},
    ));
  }

  // Newest first, then split wherever the date heading changes.
  List<DateSection<R>> _sections<T, R>(
    List<T> items, {
    required DateTime now,
    required DateTime Function(T item) dateOf,
    required R Function(T item) toItem,
  }) {
    final newestFirst = [...items]
      ..sort((a, b) => dateOf(b).compareTo(dateOf(a)));
    final sections = <DateSection<R>>[];
    for (final item in newestFirst) {
      final label = formatDateSection(dateOf(item).toLocal(), now: now);
      if (sections.isEmpty || sections.last.label != label) {
        sections.add(DateSection(label: label, items: [toItem(item)]));
      } else {
        sections.last.items.add(toItem(item));
      }
    }
    return sections;
  }

  void _emitError(String message) {
    if (isClosed) return;
    emit(state.copyWith(
      status: ChatMediaStatus.failure,
      error: UiError(message),
    ));
  }
}
