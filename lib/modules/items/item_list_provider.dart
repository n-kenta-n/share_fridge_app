import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/fridges/current_fridge_provider.dart';
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
    final fridgeId = ref.watch(currentFridgeProvider);

    // fridgeがまだ選ばれていないなら、ロード中にする
    if (fridgeId == null) return [];

    _currentPage = 1;
    _hasMore = true;
    final items = await _repository.fetch(_currentPage, 14, fridgeId, sortType);
    final signedUrlItems = await _repository.getSignedUrlItems(items);

    return signedUrlItems;
  }

  Future<void> fetchNext() async {
    final sortType = ref.watch(sortTypeProvider);
    final fridgeId = ref.watch(currentFridgeProvider);

    // fridgeがまだ選ばれていないなら、ロード中にする
    if (fridgeId == null) return;

    if (!_hasMore || _isFetching) return;
    _isFetching = true;
    _currentPage++;
    final newItems = await _repository.fetch(
      _currentPage,
      14,
      fridgeId,
      sortType,
    );

    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      final newSignedUrlItems = await _repository.getSignedUrlItems(newItems);
      state = AsyncData([...state.value ?? [], ...newSignedUrlItems]);
    }
    _isFetching = false;
  }

  Future<void> addItem(
    String itemName,
    double amount,
    String unit,
    String? limitDate,
    User user,
    String fridgeId,
    File? selectedImage,
  ) async {
    Item newItem = await ItemRepository().add(
      itemName,
      amount,
      unit,
      limitDate,
      user,
      fridgeId,
      selectedImage,
    );
    final newSignedUrlItem = await _repository.getSignedUrlItem(newItem);
    final currentItems = state.value ?? [];
    state = AsyncValue.data([newSignedUrlItem, ...currentItems]);
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
    String fridgeId,
    File? selectedImage,
  ) async {
    // DB更新
    final updatedItem = await ItemRepository().update(
      itemId,
      newAmount,
      newUnit,
      newLimitDate,
      user,
      fridgeId,
      selectedImage,
    );

    // サムネ画像を期限付きURLにする
    final updatedSignedUrlItem = await _repository.getSignedUrlItem(
      updatedItem,
    );
    final currentItems = state.value ?? [];

    final updatedItems =
        currentItems.map((item) {
          return item.id == itemId ? updatedSignedUrlItem : item;
        }).toList();

    state = AsyncValue.data(updatedItems);
  }
}
