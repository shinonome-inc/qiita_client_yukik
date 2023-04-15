import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/pages/feed_page.dart';
import 'package:qiita_client_yukik/pages/mypage.dart';
import 'package:qiita_client_yukik/pages/tag_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  static const _screens = [
    FeedPage(),
    TagPage(),
    MyPage(),
    Center(
      child: Text('setting'),
    ),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'フィード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_outline),
            label: 'タグ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'マイページ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedFontSize: 10,
        selectedFontSize: 10,
      ),
    );
  }
}
