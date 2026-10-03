import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final friend = Friend.fromJson({
      'id': 'u1',
      'name': 'David Wayne',
      'phone_number': '+445092853022',
      'avatar_url': 'https://example.com/a.png',
    });

    expect(friend.id, 'u1');
    expect(friend.name, 'David Wayne');
    expect(friend.phoneNumber, '+445092853022');
    expect(friend.avatarUrl, 'https://example.com/a.png');
  });

  test('fromJson leaves avatarUrl null when missing', () {
    final friend = Friend.fromJson({
      'id': 'u2',
      'name': 'Jean Dare',
      'phone_number': '+445092856093',
    });

    expect(friend.avatarUrl, isNull);
  });

  test('toJson leaves out the id and a missing avatar', () {
    const friend = Friend(
      id: 'u2',
      name: 'Jean Dare',
      phoneNumber: '+445092856093',
    );

    expect(friend.toJson(), {
      'name': 'Jean Dare',
      'phone_number': '+445092856093',
    });
  });
}
