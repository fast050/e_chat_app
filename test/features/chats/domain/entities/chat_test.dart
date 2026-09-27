import 'package:e_chat_app/features/chats/domain/entities/chat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final chat = Chat.fromJson({
      'id': 'c1',
      'name': 'David Wayne',
      'avatar_url': 'https://example.com/a.png',
      'last_message': 'Hi',
      'last_message_at': '2026-09-27T10:25:00.000',
      'unread_count': 5,
    });

    expect(chat.id, 'c1');
    expect(chat.name, 'David Wayne');
    expect(chat.avatarUrl, 'https://example.com/a.png');
    expect(chat.lastMessage, 'Hi');
    expect(chat.lastMessageAt, DateTime(2026, 9, 27, 10, 25));
    expect(chat.unreadCount, 5);
  });

  test('fromJson defaults optional fields', () {
    final chat = Chat.fromJson({
      'id': 'c2',
      'name': 'Jean Dare',
      'last_message_at': '2026-05-05T20:10:00.000',
    });

    expect(chat.avatarUrl, isNull);
    expect(chat.lastMessage, '');
    expect(chat.unreadCount, 0);
  });
}
