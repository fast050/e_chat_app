import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final message = Message.fromJson({
      'id': 'm1',
      'chat_id': 'c1',
      'sender_id': 'u1',
      'text': 'Hi!',
      'created_at': '2026-09-27T10:10:00.000',
    });

    expect(message.id, 'm1');
    expect(message.chatId, 'c1');
    expect(message.senderId, 'u1');
    expect(message.text, 'Hi!');
    expect(message.createdAt, DateTime(2026, 9, 27, 10, 10));
  });

  test('fromJson defaults a missing text to empty', () {
    final message = Message.fromJson({
      'id': 'm2',
      'chat_id': 'c1',
      'sender_id': 'u1',
      'created_at': '2026-09-27T10:10:00.000',
    });

    expect(message.text, '');
    expect(message.imageUrl, isNull);
  });

  test('fromJson and toJson carry the image url', () {
    final message = Message.fromJson({
      'id': 'm3',
      'chat_id': 'c1',
      'sender_id': 'u1',
      'created_at': '2026-09-27T10:10:00.000',
      'image_url': 'https://example.com/photo.png',
    });

    expect(message.imageUrl, 'https://example.com/photo.png');
    expect(message.toJson()['image_url'], 'https://example.com/photo.png');
  });

  test('toJson leaves out the server-generated id and created_at', () {
    final message = Message(
      id: 'm1',
      chatId: 'c1',
      senderId: 'u1',
      text: 'Hi!',
      createdAt: DateTime(2026, 9, 27, 10, 10),
    );

    expect(message.toJson(), {
      'chat_id': 'c1',
      'sender_id': 'u1',
      'text': 'Hi!',
    });
  });
}
