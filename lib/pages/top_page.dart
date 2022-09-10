import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0x33000000),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 220,
                ),
                const Text(
                  'Qiita Feed App',
                  style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 36,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                const Text('-PlayGround-',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFFFFFFFF),
                    )),
                Spacer(),
                SizedBox(
                  width: 327,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF468300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFFFFFFF),
                      ),
                      "ログイン",
                    ),
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
                const Text('ログインせずに利用する',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFFFFFFFF),
                    )),
                SizedBox(
                  height: 81,
                ),
              ],
            ),

            // child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //   SizedBox(
            //     height: 130,
            //   ),
            //   ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFF468300),
            //     ),
            //     child: const Text(
            //       style: TextStyle(
            //         fontSize: 14,
            //         color: const Color(0xFFFFFFFF),
            //       ),
            //       "ログイン",
            //     ),
            //   )
            // ]),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
