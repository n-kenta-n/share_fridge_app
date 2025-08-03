import 'package:supabase_flutter/supabase_flutter.dart';

class FridgeRepository {
  Future<String> getMyFridge(String userId) async {
    final fridgeId =
        await Supabase.instance.client
            .from('profiles')
            .select('fridge_id')
            .eq('user_id', userId)
            .single();
    return fridgeId['fridge_id'] as String;
  }

  Future<List<String>> getSharedFridges(String userId) async {
    final sharedFridges = await Supabase.instance.client
        .from('shared_fridges')
        .select('shared_fridge_id')
        .eq('user_id', userId);
    return sharedFridges
        .map((fridge) => fridge['shared_fridge_id'] as String)
        .toList();
  }

  Future<String> getName(String fridgeId) async {
    final userName = await Supabase.instance.client
        .from('profiles')
        .select('user_name')
        .eq('fridge_id', fridgeId)
        .single();
    return userName['user_name'] as String;
  }
}
