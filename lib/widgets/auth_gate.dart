import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/screens/root_screen.dart';
import 'package:share_fridge_app/screens/signin_screen.dart';

// ユーザがログインしているかどうかをチェックし、
// ログインしていなければサインイン画面に遷移させる
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return const SignInScreen(); // ログインしていない → サインイン画面
    } else {
      return const RootScreen(); // ログイン済み → メイン画面
    }
  }
}
