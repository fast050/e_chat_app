import 'package:e_chat_app/features/chats/domain/entities/message.dart';

abstract interface class MessagesRepository {
  /// Id of the signed-in user; messages with this sender are "mine".
  String get currentUserId;
  Future<List<Message>> fetchMessages(String chatId);
  Future<Message> sendMessage({required String chatId, required String text});
}
