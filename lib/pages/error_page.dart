import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/ui_components/app_bar_component.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarComponent(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Divider(height: 0.5),
            const SizedBox(height: 180.67),
            const Image(
              image: AssetImage('assets/images/network.png'),
              width: 66.67,
            ),
            const SizedBox(height: 42.67),
            const Text(
              'ネットワークエラー',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 6),
            const Text('お手数ですが電波の良い場所で 再度読み込みをお願いします',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF828282),
                )),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onPressed();
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
                  "再読み込みする",
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
