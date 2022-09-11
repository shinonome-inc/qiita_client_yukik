import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0x33000000),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 55,
                ),
                const Text(
                  'Feed',
                  style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 17,
                    color: Color(0xFF000000),
                  ),
                ),
                const Text('-PlayGround-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFFFFFF),
                    )),
                const Spacer(),
                SizedBox(
                  width: 327,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF468300),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFFFFF),
                      ),
                      "ログイン",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 34,
                ),
                const Text('ログインせずに利用する',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFFFFFF),
                    )),
                const SizedBox(
                  height: 81,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
