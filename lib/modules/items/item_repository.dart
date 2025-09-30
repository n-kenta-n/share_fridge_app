import 'dart:io';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:share_fridge_app/modules/items/sort_type_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class ItemRepository {
  final _supabase = Supabase.instance.client;

  Future<Item> add(
    String itemName,
    double amount,
    String unit,
    String? limitDate,
    User user,
    String fridgeId,
    File? selectedImage,
  ) async {
    final imageUrl =
        selectedImage == null
            ? null
            : await uploadImage(selectedImage, fridgeId);
    final response =
        await _supabase.from('items').insert({
          'item_name': itemName,
          'amount': amount,
          'unit': unit,
          'limit_date': limitDate,
          'user_id': user.id,
          'fridge_id': fridgeId,
          'image_url': imageUrl,
        }).select();
    final item = response[0];
    return Item.fromJson({
      'id': item['id'],
      'itemName': item['item_name'],
      'amount': item['amount'],
      'unit': item['unit'],
      'limitDate': item['limit_date'],
      'userId': item['user_id'],
      'fridgeId': item['fridge_id'],
      'imageUrl': item['image_url'],
    });
  }

  Future<List<Item>> fetch(
    int page,
    int number,
    String fridgeId,
    SortType sortType,
  ) async {
    final start = number * (page - 1);
    final end = start + number - 1;
    PostgrestList items;
    switch (sortType) {
      case SortType.addAsc:
        items = await _supabase
            .from('items')
            .select('*')
            .eq('fridge_id', fridgeId)
            .range(start, end)
            .order('created_at', ascending: false);
      case SortType.addDesc:
        items = await _supabase
            .from('items')
            .select('*')
            .eq('fridge_id', fridgeId)
            .range(start, end)
            .order('created_at', ascending: true);
      case SortType.limitAsc:
        items = await _supabase
            .from('items')
            .select('*')
            .eq('fridge_id', fridgeId)
            .range(start, end)
            .order('limit_date', ascending: false);
      case SortType.limitDesc:
        items = await _supabase
            .from('items')
            .select('*')
            .eq('fridge_id', fridgeId)
            .range(start, end)
            .order('limit_date', ascending: true);
    }
    return items
        .map(
          (item) => Item.fromJson({
            'id': item['id'],
            'itemName': item['item_name'],
            'unit': item['unit'],
            'amount': item['amount'],
            'limitDate': item['limit_date'],
            'userId': item['user_id'],
            'fridgeId': item['fridge_id'],
            'imageUrl': item['image_url'],
          }),
        )
        .toList();
  }

  Future<void> delete(int id) async {
    await removeImage(id);
    await _supabase.from('items').delete().eq('id', id);
  }

  Future<Item> update(
    int id,
    double newAmount,
    String newUnit,
    String? newLimitDate,
    User user,
    String fridgeId,
    File? selectedImage,
  ) async {
    removeImage(id);
    final newImageUrl =
        selectedImage == null
            ? null
            : await uploadImage(selectedImage, fridgeId);
    final response =
        await _supabase
            .from('items')
            .update({
              'amount': newAmount,
              'unit': newUnit,
              'limit_date': newLimitDate,
              'image_url': newImageUrl,
            })
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
      'fridgeId': item['fridge_id'],
      'imageUrl': item['image_url'],
    });
  }

  // 画像をストレージにアップロードし、ファイルパスを返す
  Future<String> uploadImage(File selectedImage, String fridgeId) async {
    final fileExt = path.extension(selectedImage.path); // 拡張子を抽出する処理
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
    final imagePath = 'images/$fridgeId/$fileName';

    await _supabase.storage.from('images').upload(imagePath, selectedImage);

    return imagePath;
  }

  // itemのidから対応する画像パスを取得し、その画像を削除
  Future<void> removeImage(int id) async {
    final imageUrlMap =
        await _supabase.from('items').select('image_url').eq('id', id).single();
    if (imageUrlMap['image_url'] != null) {
      String? imageUrl = imageUrlMap['image_url'] as String;
      await _supabase.storage.from('images').remove([imageUrl]);
    }
  }

  // Itemリストを受け取り画像URLを期限付きURLにして返すメソッド
  Future<List<Item>> getSignedUrlItems(List<Item> items) async {
    final newItems = await Future.wait(
      items.map((item) async {
        final signedUrl =
            item.imageUrl == null
                ? null
                : await _supabase.storage
                    .from('images')
                    .createSignedUrl(item.imageUrl!, 60 * 60);
        return item.copyWith(imageUrl: signedUrl);
      }),
    );
    return newItems;
  }

  // Itemを受け取り画像URLを期限付きURLにして返すメソッド
  Future<Item> getSignedUrlItem(Item item) async {
    final signedUrl =
        item.imageUrl == null
            ? null
            : await _supabase.storage
                .from('images')
                .createSignedUrl(item.imageUrl!, 60 * 60);
    final newItem = item.copyWith(imageUrl: signedUrl);
    return newItem;
  }

  Future<String?> getSignedUrl(String? imageUrl) async {
    final signedUrl =
        imageUrl == null
            ? null
            : await _supabase.storage
                .from('images')
                .createSignedUrl(imageUrl, 60 * 60);
    return signedUrl;
  }
}
