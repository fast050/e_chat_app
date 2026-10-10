import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/group.dart';
import 'package:e_chat_app/features/chats/domain/repo/groups_repository.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddToGroupCubit extends Cubit<AddToGroupState> {
  final GroupsRepository _repository;
  String? _userId;

  AddToGroupCubit(this._repository)
      : super(const AddToGroupState.initialState());

  // Called again after a group was created, so it keeps the search and never
  // goes back to loading.
  Future<void> loadGroups(String userId) async {
    _userId = userId;
    try {
      final groups = await _repository.fetchGroups();
      if (isClosed) return;
      emit(state.copyWith(
        status: AddToGroupStatus.success,
        allGroups: groups,
        groups: _filter(groups, state.searchQuery),
        addedIds: {
          for (final group in groups)
            if (group.memberIds.contains(userId)) group.id,
        },
      ));
    } on AuthException catch (e) {
      _emitLoadError(e.message);
    } on PostgrestException catch (e) {
      _emitLoadError(e.message);
    } catch (_) {
      _emitLoadError(_genericMessage);
    }
  }

  void search(String query) {
    emit(state.copyWith(
      searchQuery: query,
      groups: _filter(state.allGroups, query),
    ));
  }

  Future<void> addToGroup(String groupId) async {
    final userId = _userId;
    if (userId == null || state.addedIds.contains(groupId)) return;

    try {
      await _repository.addMember(groupId: groupId, userId: userId);
      if (isClosed) return;
      emit(state.copyWith(addedIds: {...state.addedIds, groupId}));
    } on AuthException catch (e) {
      _emitError(e.message);
    } on PostgrestException catch (e) {
      _emitError(e.message);
    } catch (_) {
      _emitError(_genericMessage);
    }
  }

  static const _genericMessage = 'Something went wrong. Please try again.';

  List<Group> _filter(List<Group> groups, String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return groups;
    return groups
        .where((group) => group.name.toLowerCase().contains(needle))
        .toList();
  }

  void _emitLoadError(String message) {
    if (isClosed) return;
    emit(state.copyWith(
      status: state.status == AddToGroupStatus.loading
          ? AddToGroupStatus.failure
          : null,
      error: UiError(message),
    ));
  }

  void _emitError(String message) {
    if (isClosed) return;
    emit(state.copyWith(error: UiError(message)));
  }
}
