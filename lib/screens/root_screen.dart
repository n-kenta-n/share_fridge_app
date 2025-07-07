import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/screens/fridge_screen.dart';
import 'package:share_fridge_app/screens/send_request_screen.dart';
import 'package:share_fridge_app/screens/setting_screen.dart';
import 'package:share_fridge_app/widgets/header.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends ConsumerState<RootScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    SettingScreen(),
    FridgeScreen(),
    SendRequestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Header(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        fixedColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'shared requests'),
        ],
      ),
    );
  }
}
