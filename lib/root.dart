import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  static const _screens = [
    Center(
      child: Text('feed'),
    ),
    Center(
      child: Text('tag'),
    ),
    Center(
      child: Text('mypage'),
    ),
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
      bottomNavigationBar: SizedBox(
        height: 49,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'フィード',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.label_outline),
              label: 'タグ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'マイページ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '設定',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedFontSize: 10,
          selectedFontSize: 10,
        ),
      ),
    );
  }
}
