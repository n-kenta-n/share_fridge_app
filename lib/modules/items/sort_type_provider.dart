import 'package:flutter_riverpod/flutter_riverpod.dart';

// ソートの種類
enum SortType { addAsc, addDesc, limitAsc, limitDesc }

// SortTypeの拡張クラス
extension SortTypeExtension on SortType {
  String get label {
    switch (this) {
      case SortType.addAsc:
        return '追加順（昇順）';
      case SortType.addDesc:
        return '追加順（降順）';
      case SortType.limitAsc:
        return '期限順（昇順）';
      case SortType.limitDesc:
        return '期限順（降順）';
    }
  }
}

// ソートの種類の選択状況を管理するプロバイダ
final sortTypeProvider = NotifierProvider<SortTypeNotifier, SortType>(
  SortTypeNotifier.new,
);

class SortTypeNotifier extends Notifier<SortType> {
  @override
  SortType build() => SortType.addAsc;

  // ソートタイプをセットするメソッド
  void set(SortType type) {
    state = type;
  }
}