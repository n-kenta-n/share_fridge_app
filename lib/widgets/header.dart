import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/auth_repository.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  void _handleMenuSelected(WidgetRef ref, int val) async {
    if (val == 1) {
      await AuthRepository().signout();
      ref.read(currentUserProvider.notifier).setCurrentUser(null);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return AppBar(
      // AppBarのTitleを中央寄せ
      centerTitle: true,
      // 左に自動で出る、戻るアイコンを無効にする
      automaticallyImplyLeading: false,
      // スクロール時の影や背景色の変化をなくす
      scrolledUnderElevation: 0,
      // スクロール時にAppBarに自動的に適用される色を透明にする
      surfaceTintColor: Colors.transparent,
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.white),
          itemBuilder:
              (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    title: Text(currentUser!.userMetadata!["name"]),
                    subtitle: Text(currentUser.email!),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    title: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
          onSelected: (val) => _handleMenuSelected(ref, val),
        ),
      ],
    );
  }
}
