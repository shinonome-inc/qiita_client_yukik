import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({Key? key, required this.title, this.data, this.onTap})
      : super(key: key);
  final String title;
  final Widget? data;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  data ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            indent: 16,
          ),
        ],
      ),
    );
  }
}
