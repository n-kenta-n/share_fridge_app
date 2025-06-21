import 'package:supabase_flutter/supabase_flutter.dart';

class FridgeRepository {
  Future<String?> get(String userId) async {
    final fridgeId =
        await Supabase.instance.client
            .from('prime_fridges')
            .select('fridge_id')
            .eq('user_id', userId)
            .single();
    return fridgeId['fridge_id'] as String;
  }
}
