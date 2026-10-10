import 'package:e_chat_app/features/chats/domain/entities/document_attachment.dart';
import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';

abstract interface class AttachmentsRepository {
  Future<List<LinkAttachment>> fetchLinks(String chatId);
  Future<List<DocumentAttachment>> fetchDocuments(String chatId);
}
