import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_client_yukik/pages/login_page.dart';
import 'package:qiita_client_yukik/root.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final String clientId = dotenv.get('CLIENT_ID');
  final String clientSecret = dotenv.get('CLIENT_SECRET');

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 220,
                ),
                const Text(
                  'Qiita Feed App',
                  style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 36,
                    color: Color(0xFFFFFFFF),
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
                    onPressed: () {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: LogInPage(
                                  url:
                                      'https://qiita.com/api/v2/oauth/authorize?client_id=$clientId&scope=read_qiita&state=bb17785d811bb1913ef54b0a7657de780defaa2d'),
                            );
                          });
                    },
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
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Root()));
                    },
                    child: const Text('ログインせずに利用する',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFFFFFF),
                        ))),
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
