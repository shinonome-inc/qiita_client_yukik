import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget with PreferredSizeWidget {
  const AppBarComponent({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Pacifico-Regular',
            fontSize: 17,
          )),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
