import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/modules/requests/request.dart';
import 'package:share_fridge_app/modules/requests/request_repository.dart';

final requestListProvider = AsyncNotifierProvider<RequestListNotifier, List<Request>>(
    RequestListNotifier.new,
);

class RequestListNotifier extends AsyncNotifier<List<Request>> {
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

    final requests = await _repository.fetchRequests(
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
    final newRequests = await _repository.fetchRequests(
      _currentPage,
      10,
      user!
    );

    if (newRequests.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...state.value ?? [], ...newRequests]);
    }
    _isFetching = false;
  }
}