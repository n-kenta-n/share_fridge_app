import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'item_repository.dart';

/*
final itemListProvider = NotifierProvider<ItemListStore, List<Item>>(
  ItemListStore.new,
);

class ItemListStore extends Notifier<List<Item>> {
  @override
  List<Item> build() {
    return [];
  }

  void add(Item item) {
    state = [...state, item];
  }

  void remove(int id) {
    state = state.where((item) => item.id != id).toList();
  }

  void update(Item updatedItem) {
    state =
        state
            .map((item) => item.id == updatedItem.id ? updatedItem : item)
            .toList();
  }

  void clear() {
    state = [];
  }
}
*/

final itemListProvider = AsyncNotifierProvider<ItemListNotifier, List<Item>>(
  ItemListNotifier.new,
);

class ItemListNotifier extends AsyncNotifier<List<Item>> {
  final _repository = ItemRepository();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;

  @override
  FutureOr<List<Item>> build() async {
    return await _fetchInitial();
  }

  Future<List<Item>> _fetchInitial() async {
    _currentPage = 1;
    _hasMore = true;
    final items = await _repository.fetch(_currentPage, 20);
    return items;
  }

  Future<void> fetchNext() async {
    if (!_hasMore || _isFetching) return;
    _isFetching = true;
    _currentPage++;
    final newItems = await _repository.fetch(_currentPage, 20);

    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...state.value ?? [], ...newItems]);
    }
    _isFetching = false;
  }

  Future<void> addItem(
    String itemName,
    double amount,
    String? limitDate,
    User user,
  ) async {
    Item newItem = await ItemRepository().add(
      itemName,
      amount,
      limitDate,
      user,
    ); // DBに追加
    final currentItems = state.value ?? [];
    state = AsyncValue.data([newItem, ...currentItems]);
  }

  Future<void> removeItem(int itemId) async {
    await ItemRepository().delete(itemId); // DBから削除
    final currentItems = state.value ?? [];
    state = AsyncValue.data(
      currentItems.where((item) => item.id != itemId).toList(),
    );
  }

  Future<void> updateItem(
    int itemId,
    double newAmount,
    String? newLimitDate,
    User user,
  ) async {
    // DB更新
    final updatedItem = await ItemRepository().update(
      itemId,
      newAmount,
      newLimitDate,
      user,
    );
    final currentItems = state.value ?? [];
    final updatedItems =
        currentItems.map((item) {
          return item.id == itemId ? updatedItem : item;
        }).toList();

    state = AsyncValue.data(updatedItems);
  }

  // テスト用
  Future<Item> testFetch(int id) async {
    final item = await ItemRepository().testFetch(id);
    return item;
  }
}
