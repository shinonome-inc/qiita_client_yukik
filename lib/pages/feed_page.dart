import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_client_yukik/models/article.dart';
import 'package:qiita_client_yukik/models/fetch.dart';
import 'package:qiita_client_yukik/pages/feed_detail.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Article>> futureArticle;

  @override
  void initState() {
    super.initState();
    futureArticle = API().fetchArticle('https://qiita.com/api/v2/items');
  }

  Widget _listView(List<Article> items) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all(0),
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                        // height: double.parse(WebViewController().runJavaScriptReturningResult('document.documentElement.scrollHeight;').toString()) ?? MediaQuery.of(context).size.height * 0.9,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: FeedDetail(url: items[index].webUrl));
                  });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(items[index].users.imgUrl),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index].title,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '@${items[index].users.userId.toString()}'
                          '　投稿日：${DateFormat('yyyy/MM/dd').format(items[index].createdAt)}'
                          '　いいね：${items[index].likes.toString()}',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF828282)),
                        ),
                        const Divider(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico-Regular',
              fontSize: 17,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Divider(height: 0.5),
          SizedBox(
            height: 8,
            child: Container(
              color: Colors.white,
            ),
          ),
          FutureBuilder<List<Article>>(
            future: API().fetchArticle('https://qiita.com/api/v2/items'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _listView(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
