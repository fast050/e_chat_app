import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/repo/friends_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/groups_repository.dart';
import 'package:e_chat_app/features/chats/ui/logic/create_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final FriendsRepository _friendsRepository;
  final GroupsRepository _groupsRepository;

  CreateGroupCubit(this._friendsRepository, this._groupsRepository)
      : super(const CreateGroupState.initialState());

  Future<void> loadFriends() async {
    emit(state.copyWith(isLoadingFriends: true));
    try {
      final friends = await _friendsRepository.fetchFriends();
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingFriends: false,
        friends: friends,
        pickerFriends: friends,
      ));
    } on AuthException catch (e) {
      _emitLoadFailure(e.message);
    } on PostgrestException catch (e) {
      _emitLoadFailure(e.message);
    } catch (_) {
      _emitLoadFailure(_genericMessage);
    }
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void openMemberPicker() {
    emit(state.copyWith(
      pickerFriends: state.friends,
      pickerSelectedIds: {for (final member in state.members) member.id},
    ));
  }

  void searchFriends(String query) {
    final needle = query.trim().toLowerCase();
    emit(state.copyWith(
      pickerFriends: needle.isEmpty
          ? state.friends
          : state.friends
              .where((friend) =>
                  friend.name.toLowerCase().contains(needle) ||
                  friend.phoneNumber.contains(needle))
              .toList(),
    ));
  }

  void toggleMember(String friendId) {
    final selected = {...state.pickerSelectedIds};
    if (!selected.remove(friendId)) selected.add(friendId);
    emit(state.copyWith(pickerSelectedIds: selected));
  }

  void confirmMembers() {
    emit(state.copyWith(
      members: state.friends
          .where((friend) => state.pickerSelectedIds.contains(friend.id))
          .toList(),
    ));
  }

  Future<void> createGroup() async {
    if (state.status == CreateGroupStatus.submitting) return;
    final name = state.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(error: UiError('Enter a group name.')));
      return;
    }
    if (state.members.isEmpty) {
      emit(state.copyWith(error: UiError('Add at least one member.')));
      return;
    }

    emit(state.copyWith(status: CreateGroupStatus.submitting));
    try {
      await _groupsRepository.createGroup(
        name: name,
        memberIds: state.members.map((member) => member.id).toList(),
      );
      if (isClosed) return;
      emit(state.copyWith(status: CreateGroupStatus.success));
    } on AuthException catch (e) {
      _emitCreateFailure(e.message);
    } on PostgrestException catch (e) {
      _emitCreateFailure(e.message);
    } catch (_) {
      _emitCreateFailure(_genericMessage);
    }
  }

  static const _genericMessage = 'Something went wrong. Please try again.';

  void _emitLoadFailure(String message) {
    if (isClosed) return;
    emit(state.copyWith(isLoadingFriends: false, error: UiError(message)));
  }

  void _emitCreateFailure(String message) {
    if (isClosed) return;
    emit(state.copyWith(
      status: CreateGroupStatus.failure,
      error: UiError(message),
    ));
  }
}
