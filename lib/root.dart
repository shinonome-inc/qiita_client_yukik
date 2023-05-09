import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/pages/feed_page.dart';
import 'package:qiita_client_yukik/pages/my_page.dart';
import 'package:qiita_client_yukik/pages/settings_page.dart';
import 'package:qiita_client_yukik/pages/tag_page.dart';

class Root extends StatefulWidget {
  const Root({super.key, required this.page_index});
  final int page_index;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  static const _screens = [
    FeedPage(),
    TagPage(),
    MyPage(),
    SettingPage(),
  ];
  int? _selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex ?? widget.page_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex ?? widget.page_index,
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
