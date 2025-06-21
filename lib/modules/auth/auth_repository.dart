import 'package:supabase_flutter/supabase_flutter.dart';

// supabaseのサインインやサインアップのメソッドを定義するクラス
class AuthRepository {
  Future<void> signUp(String name, String email, String password) async {
    await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      data: {"name": name},
    );
  }

  Future<User?> signIn(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<User?> getCurrentUser() async {
    final response = await Supabase.instance.client.auth.getUser();
    return response.user;
  }

  Future<bool> signOut() async {
    await Supabase.instance.client.auth.signOut();
    return true;
  }
}
