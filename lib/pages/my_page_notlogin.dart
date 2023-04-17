import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/pages/top_page.dart';

class MyPageNotLogin extends StatefulWidget {
  const MyPageNotLogin({super.key});

  @override
  State<MyPageNotLogin> createState() => _MyPageNotLoginState();
}

class _MyPageNotLoginState extends State<MyPageNotLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MyPage',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico-Regular',
              fontSize: 17,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 220,
            ),
            const Text(
              'ログインが必要です',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            const Text('マイページの機能を利用するには\nログインを行っていただく必要があります。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF828282),
                )),
            const Spacer(),
            SizedBox(
              width: 327,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const TopPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF74C13A),
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
                  "ログインする",
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
