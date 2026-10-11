import 'package:e_chat_app/features/chats/domain/entities/group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final group = Group.fromJson({
      'id': 'g1',
      'name': 'Diamond Team',
      'member_ids': ['u1', 'u2'],
      'last_message': 'Thanks a bunch!',
      'avatar_urls': ['https://example.com/a.png'],
    });

    expect(group.id, 'g1');
    expect(group.name, 'Diamond Team');
    expect(group.memberIds, ['u1', 'u2']);
    expect(group.lastMessage, 'Thanks a bunch!');
    expect(group.avatarUrls, ['https://example.com/a.png']);
  });

  test('fromJson defaults a missing last message and avatars to empty', () {
    final group = Group.fromJson({
      'id': 'g2',
      'name': 'Delivery',
      'member_ids': <String>[],
    });

    expect(group.lastMessage, '');
    expect(group.avatarUrls, isEmpty);
  });

  test('toJson writes only the name and members', () {
    const group = Group(
      id: 'g1',
      name: 'Diamond Team',
      memberIds: ['u1'],
      lastMessage: 'Thanks a bunch!',
    );

    expect(group.toJson(), {
      'name': 'Diamond Team',
      'member_ids': ['u1'],
    });
  });
}
