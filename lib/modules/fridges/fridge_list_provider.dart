import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'fridge.dart';
import 'fridge_repository.dart';

final fridgeListProvider = AsyncNotifierProvider<FridgeListProvider, List<Fridge>>(
  FridgeListProvider.new,
);

class FridgeListProvider extends AsyncNotifier<List<Fridge>> {
  final _repository = FridgeRepository();

  @override
  Future<List<Fridge>> build() async {
    return await _fetch();
  }

  Future<List<Fridge>> _fetch() async {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) return [];

    final myFridgeId = await _repository.getMyFridge(currentUser.id);
    final sharedFridgeIds = await _repository.getSharedFridges(currentUser.id);
    final allFridgeIds = [myFridgeId, ...sharedFridgeIds];

    // fridgeId → userName を変換
    final fridges = await Future.wait(allFridgeIds.map((id) async {
      final name = await _repository.getName(id);
      return Fridge(fridgeId: id, userName: name);
    }));

    return fridges;
  }
}