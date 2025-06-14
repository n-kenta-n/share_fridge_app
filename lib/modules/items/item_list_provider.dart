import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:share_fridge_app/modules/items/sort_type_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'item_repository.dart';

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
    final sortType = ref.watch(sortTypeProvider);
    _currentPage = 1;
    _hasMore = true;
    final items = await _repository.fetch(_currentPage, 10, sortType);
    return items;
  }

  Future<void> fetchNext() async {
    final sortType = ref.watch(sortTypeProvider);
    if (!_hasMore || _isFetching) return;
    _isFetching = true;
    _currentPage++;
    final newItems = await _repository.fetch(_currentPage, 10, sortType);

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
    String unit,
    String? limitDate,
    User user,
  ) async {
    Item newItem = await ItemRepository().add(
      itemName,
      amount,
      unit,
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
    String newUnit,
    String? newLimitDate,
    User user,
  ) async {
    // DB更新
    final updatedItem = await ItemRepository().update(
      itemId,
      newAmount,
      newUnit,
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
}
