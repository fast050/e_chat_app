import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:e_chat_app/features/chats/domain/repo/messages_repository.dart';

// In-memory sample data until the Supabase messages table exists.
class MessagesRepositoryImpl implements MessagesRepository {
  static const _me = 'me';

  final _messagesByChat = <String, List<Message>>{};

  @override
  String get currentUserId => _me;

  @override
  Future<List<Message>> fetchMessages(String chatId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_messagesOf(chatId));
  }

  @override
  Future<Message> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final messages = _messagesOf(chatId);
    final message = Message(
      id: '$chatId-${messages.length + 1}',
      chatId: chatId,
      senderId: _me,
      text: text,
      createdAt: DateTime.now(),
    );
    messages.add(message);
    return message;
  }

  List<Message> _messagesOf(String chatId) =>
      _messagesByChat.putIfAbsent(chatId, () => _sampleMessages(chatId));

  List<Message> _sampleMessages(String chatId) {
    final now = DateTime.now();
    var count = 0;
    // The sample chat ids double as the other user's id.
    Message message(String senderId, int minute, int second, String text) =>
        Message(
          id: '$chatId-${++count}',
          chatId: chatId,
          senderId: senderId,
          text: text,
          createdAt: DateTime(now.year, now.month, now.day, 10, minute, second),
        );

    return [
      message(
        chatId,
        10,
        0,
        'Hello! This is your delivery driver from Speedy Chow. '
            "I'm just around the corner from your place. 😊",
      ),
      message(_me, 10, 30, 'Hi!'),
      message(
        _me,
        11,
        0,
        "Awesome, thanks for letting me know! Can't wait for my delivery. 🎉",
      ),
      message(
        chatId,
        11,
        20,
        "No problem at all!\nI'll be there in about 15 minutes.",
      ),
      message(chatId, 11, 40, "I'll text you when I arrive."),
      message(_me, 12, 0, 'Great! 😊'),
    ];
  }
}
