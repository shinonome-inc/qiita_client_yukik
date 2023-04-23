import 'package:flutter/material.dart';

import 'app_bar_component.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({Key? key, required this.title, required this.sentence})
      : super(key: key);
  final String title;
  final String sentence;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarComponent(title: title),
              Text(sentence),
            ],
          ),
        ));
  }
}
