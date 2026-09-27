import 'package:e_chat_app/features/chats/domain/entities/chat.dart';

abstract interface class ChatsRepository {
  Future<List<Chat>> fetchChats();
}
