import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final link = LinkAttachment.fromJson({
      'id': 'l1',
      'chat_id': 'c1',
      'url': 'https://example.com/kit',
      'title': 'Tab Bar Components',
      'thumbnail_url': 'https://example.com/kit.png',
      'created_at': '2026-09-27T10:10:00.000',
    });

    expect(link.id, 'l1');
    expect(link.chatId, 'c1');
    expect(link.url, 'https://example.com/kit');
    expect(link.title, 'Tab Bar Components');
    expect(link.thumbnailUrl, 'https://example.com/kit.png');
    expect(link.createdAt, DateTime(2026, 9, 27, 10, 10));
  });

  test('fromJson handles a missing title and thumbnail', () {
    final link = LinkAttachment.fromJson({
      'id': 'l2',
      'chat_id': 'c1',
      'url': 'https://example.com/kit',
      'created_at': '2026-09-27T10:10:00.000',
    });

    expect(link.title, '');
    expect(link.thumbnailUrl, isNull);
  });

  test('toJson leaves out the id, created_at and a missing thumbnail', () {
    final link = LinkAttachment(
      id: 'l1',
      chatId: 'c1',
      url: 'https://example.com/kit',
      title: 'Tab Bar Components',
      createdAt: DateTime(2026, 9, 27, 10, 10),
    );

    expect(link.toJson(), {
      'chat_id': 'c1',
      'url': 'https://example.com/kit',
      'title': 'Tab Bar Components',
    });
  });
}
