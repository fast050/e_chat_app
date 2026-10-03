import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/domain/repo/friends_repository.dart';

// In-memory sample data until the Supabase profiles/friendships tables exist.
class FriendsRepositoryImpl implements FriendsRepository {
  static const _users = [
    Friend(
      id: '1',
      name: 'David Wayne',
      phoneNumber: '+445092853022',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    Friend(
      id: '2',
      name: 'Edward Davidson',
      phoneNumber: '+445092851177',
      avatarUrl: 'https://i.pravatar.cc/150?img=13',
    ),
    Friend(
      id: '3',
      name: 'Angela Kelly',
      phoneNumber: '+445092854410',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Friend(
      id: '4',
      name: 'Jean Dare',
      phoneNumber: '+445092856093',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
    ),
    Friend(
      id: '5',
      name: 'Dennis Borer',
      phoneNumber: '+445092858256',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
    ),
    Friend(
      id: '6',
      name: 'Cayla Rath',
      phoneNumber: '+445092852731',
      avatarUrl: 'https://i.pravatar.cc/150?img=20',
    ),
    Friend(
      id: '7',
      name: 'Erin Turcotte',
      phoneNumber: '+445092859904',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
    ),
    Friend(
      id: '8',
      name: 'Rodolfo Walter',
      phoneNumber: '+445092857348',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
    ),
  ];

  final _friendIds = <String>{'1', '2', '3', '4', '5'};

  @override
  Future<List<Friend>> searchByPhone(String phoneNumber) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _users
        .where((user) =>
            !_friendIds.contains(user.id) &&
            user.phoneNumber.startsWith(phoneNumber))
        .toList();
  }

  @override
  Future<void> addFriend(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _friendIds.add(userId);
  }

  @override
  Future<List<Friend>> fetchFriends() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _users.where((user) => _friendIds.contains(user.id)).toList();
  }
}
