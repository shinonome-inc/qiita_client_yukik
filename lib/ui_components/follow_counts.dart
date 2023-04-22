import 'package:flutter/cupertino.dart';

class FollowCounts extends StatelessWidget {
  const FollowCounts({Key? key, required this.count, required this.isFollowers})
      : super(key: key);
  final int count;
  final bool isFollowers;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          isFollowers ? 'フォロワー' : 'フォロー中　',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF828282),
          ),
        )
      ],
    );
  }
}
