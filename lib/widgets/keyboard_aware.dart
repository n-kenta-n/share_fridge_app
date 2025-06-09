import 'package:flutter/material.dart';

// ソフトウェアキーボードが表示されているときに、
// 入力フィールドの外をタップするとソフトウェアキーボードが消えるようにする処理
class KeyboardAware extends StatelessWidget {
  const KeyboardAware({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
