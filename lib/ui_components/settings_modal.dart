import 'package:flutter/material.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({Key? key, required this.title, required this.sentence})
      : super(key: key);
  final String title;
  final String sentence;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Text(title,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Pacifico-Regular',
                fontSize: 17,
              )),
          const SizedBox(
            height: 12,
          ),
          const Divider(
            height: 0.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(sentence),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
