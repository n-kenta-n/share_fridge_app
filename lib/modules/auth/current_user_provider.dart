import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/* Riverpod 2.0以前の記述方法
final currentUserProvider = StateNotifierProvider<CurrentUserStore, User?>(
        (ref) {
      return CurrentUserStore(ref);
    }
);

// ユーザのグローバルステイトを定義するクラス
class CurrentUserStore extends StateNotifier<User?> {
  CurrentUserStore(this.ref) : super(null);
  final Ref ref;

  // 現在のユーザをstateにセットするメソッド
  void setCurrentUser(User? user) {
    state = user;
  }
}
*/

// Riverpod 3.0以降の記述方法
// StateNotifierProviderは非推奨(Legacy)になりました
final currentUserProvider = NotifierProvider<CurrentUserStore, User?>(
  CurrentUserStore.new,
  retry: (retryCount, error) => null, // リトライ処理を無効化
);

// ユーザのグローバルステイトを定義するクラス
class CurrentUserStore extends Notifier<User?> {
  @override
  User? build() {
    return null; // 初期化状態（ログインしていない）
  }

  // 現在のユーザをstateにセットするメソッド
  void setCurrentUser(User? user) {
    state = user;
  }
}
