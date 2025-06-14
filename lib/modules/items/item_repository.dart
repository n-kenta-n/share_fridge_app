import 'package:share_fridge_app/modules/items/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemRepository {
  Future<Item> add(
    String itemName,
    double amount,
    String unit,
    String? limitDate,
    User user,
  ) async {
    final response =
        await Supabase.instance.client.from('items').insert({
          'item_name': itemName,
          'amount': amount,
          'unit': unit,
          'limit_date': limitDate,
          'user_id': user.id,
        }).select();
    final item = response[0];
    return Item.fromJson({
      'id': item['id'],
      'itemName': item['item_name'],
      'amount': item['amount'],
      'unit': item['unit'],
      'limitDate': item['limit_date'],
      'userId': item['user_id'],
    });
  }

  Future<List<Item>> fetch(int page, int number) async {
    final start = number * (page - 1);
    final end = start + number - 1;
    final items = await Supabase.instance.client
        .from('items')
        .select('*')
        .range(start, end)
        .order('created_at', ascending: false);
    // .order('id', ascending: true);
    return items
        .map(
          (item) => Item.fromJson({
            'id': item['id'],
            'itemName': item['item_name'],
            'unit': item['unit'],
            'amount': item['amount'],
            'limitDate': item['limit_date'],
            'userId': item['user_id'],
          }),
        )
        .toList();
  }

  Future<void> delete(int id) async {
    await Supabase.instance.client.from('items').delete().eq('id', id);
  }

  Future<Item> update(
    int id,
    double newAmount,
    String newUnit,
    String? newLimitDate,
    User user,
  ) async {
    final response =
        await Supabase.instance.client
            .from('items')
            .update({'amount': newAmount, 'unit': newUnit, 'limit_date': newLimitDate})
            .eq('id', id)
            .select();
    final item = response.first;
    return Item.fromJson({
      'id': item['id'],
      'itemName': item['item_name'],
      'amount': item['amount'],
      'unit': item['unit'],
      'limitDate': item['limit_date'],
      'userId': item['user_id'],
    });
  }
}
