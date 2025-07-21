import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/auth_repository.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/widgets/keyboard_aware.dart';

import '../modules/fridges/current_fridge_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends ConsumerState<SignInScreen> {
  String _email = "";
  String _password = "";

  // サインインを行うメソッド
  void _signIn() async {
    try {
      final user = await AuthRepository().signIn(_email, _password);
      if (user == null) {
        _showDialog('失敗');
        return;
      }
      ref.read(currentUserProvider.notifier).setCurrentUser(user);
      ref.read(currentFridgeProvider.notifier).setMyFridgeId(user.id);
    } catch (e) {
      print('Error: $e');
      _showDialog('失敗');
    }
  }

  // サインイン失敗or成功時のダイアログ生成メソッド
  Future<void> _showDialog(String isSuccess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text('サインインに$isSuccessしました')]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Share Fridge',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: KeyboardAware(
        child: Column(
          children: [
            Expanded(
              // 子ウィジェットをスクロール可能にする
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged:
                            (val) => setState(() {
                              _email = val;
                            }),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        obscureText: true,
                        onChanged:
                            (val) => setState(() {
                              _password = val;
                            }),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _email.isNotEmpty && _password.isNotEmpty
                                  ? _signIn
                                  : null,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors.grey;
                                  }
                                  return Colors.black;
                                }),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          textStyle: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed:
                            () => Navigator.pushNamed(context, "/signup"),
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
