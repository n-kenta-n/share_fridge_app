import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/modules/requests/request.dart';
import 'package:share_fridge_app/modules/requests/request_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final receivedRequestsProvider =
    AsyncNotifierProvider<ReceivedRequestsNotifier, List<Request>>(
      ReceivedRequestsNotifier.new,
    );

final sentRequestsProvider =
    AsyncNotifierProvider<SentRequestsNotifier, List<Request>>(
      SentRequestsNotifier.new,
    );

class ReceivedRequestsNotifier extends AsyncNotifier<List<Request>> {
  final _repository = RequestRepository();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  FutureOr<List<Request>> build() async {
    return await _fetchInitial();
  }

  Future<List<Request>> _fetchInitial() async {
    final user = ref.watch(currentUserProvider);
    _currentPage = 1;
    _hasMore = true;

    final requests = await _repository.fetchReceivedRequests(
      _currentPage,
      10,
      user!,
    );
    return requests;
  }

  Future<void> fetchNext() async {
    final user = ref.watch(currentUserProvider);
    if (!_hasMore || _isFetching) return;
    _isFetching = true;
    _currentPage++;
    final newRequests = await _repository.fetchReceivedRequests(
      _currentPage,
      10,
      user!,
    );

    if (newRequests.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...state.value ?? [], ...newRequests]);
    }
    _isFetching = false;
  }

  Future<void> acceptRequest(Request request, User currentUser) async {
    final acceptedRequest = await _repository.acceptRequest(
      request,
      currentUser,
    );
    final currentRequests = state.value ?? [];
    final updatedRequests =
        currentRequests.map((r) {
          return r.id == request.id ? acceptedRequest : r;
        }).toList();

    state = AsyncValue.data(updatedRequests);
  }

  Future<void> rejectRequest(Request request) async {
    final rejectedRequest = await _repository.rejectRequest(request);
    final currentRequests = state.value ?? [];
    final updatedRequests =
        currentRequests.map((r) {
          return r.id == request.id ? rejectedRequest : r;
        }).toList();

    state = AsyncValue.data(updatedRequests);
  }
}

class SentRequestsNotifier extends AsyncNotifier<List<Request>> {
  final _repository = RequestRepository();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  FutureOr<List<Request>> build() async {
    return await _fetchInitial();
  }

  Future<List<Request>> _fetchInitial() async {
    final user = ref.watch(currentUserProvider);
    _currentPage = 1;
    _hasMore = true;

    final requests = await _repository.fetchSentRequests(
      _currentPage,
      10,
      user!,
    );
    return requests;
  }

  Future<void> fetchNext() async {
    final user = ref.watch(currentUserProvider);
    if (!_hasMore || _isFetching) return;
    _isFetching = true;
    _currentPage++;
    final newRequests = await _repository.fetchSentRequests(
      _currentPage,
      10,
      user!,
    );

    if (newRequests.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...state.value ?? [], ...newRequests]);
    }
    _isFetching = false;
  }

  Future<bool> sendRequest(User user, String toUserEmail) async {
    bool isSuccess = false;
    final newRequest = await _repository.sendRequest(user, toUserEmail);
    if (newRequest == null) {
      return isSuccess;
    }
    final currentRequests = state.value ?? [];
    state = AsyncValue.data([newRequest, ...currentRequests]);

    isSuccess = true;
    return isSuccess;
  }
}
