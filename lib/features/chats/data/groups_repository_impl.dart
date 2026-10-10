import 'package:e_chat_app/features/chats/domain/entities/group.dart';
import 'package:e_chat_app/features/chats/domain/repo/groups_repository.dart';

// In-memory sample data until the Supabase groups tables exist.
class GroupsRepositoryImpl implements GroupsRepository {
  final _groups = <Group>[
    const Group(
      id: 'g1',
      name: 'Diamond Team 💎',
      memberIds: ['2', '3'],
      lastMessage: 'Thanks a bunch! Have a great day! 😊',
      avatarUrls: [
        'https://i.pravatar.cc/150?img=13',
        'https://i.pravatar.cc/150?img=5',
      ],
    ),
    const Group(
      id: 'g2',
      name: 'Group Shares Experience',
      memberIds: ['1', '4'],
      lastMessage: 'Great, thanks so much! 💫',
      avatarUrls: [
        'https://i.pravatar.cc/150?img=12',
        'https://i.pravatar.cc/150?img=9',
      ],
    ),
    const Group(
      id: 'g3',
      name: 'My charity group ❤️',
      memberIds: ['3', '5', '6'],
      lastMessage: 'Appreciate it! See you soon! 🚀',
      avatarUrls: [
        'https://i.pravatar.cc/150?img=5',
        'https://i.pravatar.cc/150?img=15',
      ],
    ),
    const Group(
      id: 'g4',
      name: 'Delivery',
      memberIds: ['7'],
      lastMessage: 'Your order has been successfully delivered.',
      avatarUrls: ['https://i.pravatar.cc/150?img=25'],
    ),
    const Group(
      id: 'g5',
      name: 'Sky-diving Lion Team',
      memberIds: ['6', '8'],
      lastMessage: 'See you soon!',
      avatarUrls: [
        'https://i.pravatar.cc/150?img=20',
        'https://i.pravatar.cc/150?img=33',
      ],
    ),
    const Group(
      id: 'g6',
      name: 'IT Training',
      memberIds: ['2', '8'],
      lastMessage: 'Appreciate it! Hope you enjoy it! 😊',
      avatarUrls: [
        'https://i.pravatar.cc/150?img=13',
        'https://i.pravatar.cc/150?img=33',
      ],
    ),
  ];

  @override
  Future<void> createGroup({
    required String name,
    required List<String> memberIds,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _groups.insert(
      0,
      Group(id: 'g${_groups.length + 1}', name: name, memberIds: memberIds),
    );
  }

  @override
  Future<List<Group>> fetchGroups() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_groups);
  }

  @override
  Future<void> addMember({
    required String groupId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    if (group.memberIds.contains(userId)) return;
    _groups[index] = Group(
      id: group.id,
      name: group.name,
      memberIds: [...group.memberIds, userId],
      lastMessage: group.lastMessage,
      avatarUrls: group.avatarUrls,
    );
  }
}
