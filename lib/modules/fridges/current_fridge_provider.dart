import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/fridges/fridge_repository.dart';

final currentFridgeProvider = NotifierProvider<CurrentFridgeStore, String?>(
  CurrentFridgeStore.new,
  retry: (retryCount, error) => null, // リトライ処理を無効化
);

class CurrentFridgeStore extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  Future<void> setMyFridgeId(String userId) async {
    final fridgeId = await FridgeRepository().getMyFridge(userId);
    state = fridgeId;
  }

  void setFridgeId(String fridgeId) {
    state = fridgeId;
  }
}
