import 'package:e_chat_app/features/chats/domain/entities/friend.dart';

abstract interface class FriendsRepository {
  /// Users who are not friends yet and whose number starts with [phoneNumber].
  Future<List<Friend>> searchByPhone(String phoneNumber);
  Future<void> addFriend(String userId);
  Future<List<Friend>> fetchFriends();
}
