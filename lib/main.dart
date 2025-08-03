import 'package:flutter/material.dart';
import 'package:share_fridge_app/modules/fridges/current_fridge_provider.dart';
import 'package:share_fridge_app/screens/root_screen.dart';
import 'package:share_fridge_app/widgets/auth_gate.dart';
import 'package:share_fridge_app/widgets/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/auth_repository.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_fridge_app/screens/signin_screen.dart';
import 'package:share_fridge_app/screens/signup_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_API_KEY"]!,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trySignIn();
  }

  // サインインセッションが残っている場合、currentUserにユーザ情報を格納する
  void _trySignIn() async {
    try {
      final currentUser = await AuthRepository().getCurrentUser();
      if (currentUser == null) return;
      ref.read(currentUserProvider.notifier).setCurrentUser(currentUser);
      ref.read(currentFridgeProvider.notifier).setMyFridgeId(currentUser.id);
    } on AuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ライトモードのテーマ設定
      theme: lightTheme,
      // ダークモードのテーマ設定
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // ルート定義（画面遷移）
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => const RootScreen(),
            );
          case "/signIn":
            return MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            );
          case "/signup":
            return MaterialPageRoute(
              builder: (context) => const SignupScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const RootScreen(),
            );
        }
      },
      home: const AuthGate(),
    );
  }
}
