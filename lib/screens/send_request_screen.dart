import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/screens/request_list_screen.dart';
import 'package:share_fridge_app/widgets/keyboard_aware.dart';
import '../modules/auth/current_user_provider.dart';
import '../modules/requests/request_repository.dart';

class SendRequestScreen extends ConsumerStatefulWidget {
  const SendRequestScreen({super.key});

  @override
  SendRequestState createState() => SendRequestState();
}

class SendRequestState extends ConsumerState<SendRequestScreen> {
  final TextEditingController _toUserController = TextEditingController();

  @override
  void dispose() {
    _toUserController.dispose();
    super.dispose();
  }

  Future<void> _sendRequest(String toUserEmail) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    bool isSuccess = await RequestRepository().sendRequest(user, toUserEmail);
    final resultText =
        isSuccess
            ? const Text('シェアリクエストを送りました')
            : const Text('すでにシェアリクエストを送っています');
    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[resultText]),
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

  Future<void> _sendRequestDialog(String toUserEmail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('$toUserEmail にシェアリクエストを送りますか？')],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(milliseconds: 200));
                _sendRequest(toUserEmail);
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ここから画面描画
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: KeyboardAware(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '相手のEmail',
                    // hintText: '相手のEmail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: _toUserController,
                ),
              ),
              const SizedBox(height: 16.0),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _toUserController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed:
                        (value.text.isEmpty)
                            ? null
                            : () => _sendRequestDialog(value.text),
                    child: const Text('シェアリクエストを送る'),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestListScreen(),
                      fullscreenDialog: false,
                    ),
                  );
                },
                child: Text('届いたリクエスト一覧'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
