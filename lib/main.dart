import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/auth_repository.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_fridge_app/screens/fridge_screen.dart';
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
  bool _initialized = false; // サインインセッションが残っているかどうかの判定用変数

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trySignin();
  }

  // サインインセッションが残っている場合、currentUserにユーザ情報を格納する
  void _trySignin() async {
    try {
      final currentUser = await AuthRepository().getCurrentUser();
      if (currentUser == null) return;
      ref.read(currentUserProvider.notifier).setCurrentUser(currentUser);
    } on AuthException catch (e) {
      print(e);
    } finally {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ライトモードのテーマ設定
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF000000)),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
      ),
      // ダークモードのテーマ設定
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF000000)),
        scaffoldBackgroundColor: Color(0xFF303030),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF232323),
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      themeMode: ThemeMode.system,
      // ルート定義（画面遷移）
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => const FridgeScreen(),
            );
          case "/signin":
            return MaterialPageRoute(
              builder: (context) => const SigninScreen(),
            );
          case "/signup":
            return MaterialPageRoute(
              builder: (context) => const SignupScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const FridgeScreen(),
            );
        }
      },
      // サインインセッションが残っていれば FridgeScreen, 残っていなければ SigninScreen
      home:
          _initialized
              ? Consumer(
                builder: (context, ref, _) {
                  final currentUser = ref.watch(currentUserProvider);
                  if (currentUser == null) return const SigninScreen();
                  return const FridgeScreen();
                },
              )
              : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
    );
  }
}
