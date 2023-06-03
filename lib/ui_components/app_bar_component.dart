import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({Key? key, this.title, this.leading}) : super(key: key);
  final String? title;
  final bool? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Pacifico-Regular',
            fontSize: 17,
          )),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: leading ?? true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
