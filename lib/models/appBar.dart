import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AppBarModel(String tit) {
  return AppBar(
    title: Text(tit,
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
