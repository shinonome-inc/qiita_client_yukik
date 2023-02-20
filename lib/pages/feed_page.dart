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
  String onChangedText = '';
  String onFieldSubmittedText = '';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureArticle = API().fetchArticle();
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
                    return Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
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

  Widget _textField() {
    return TextFormField(
      autocorrect: true,
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(10, 12, 12, 10),
        hintStyle: TextStyle(
          color: Color(0x993C3C43),
          fontSize: 17,
        ),
        filled: true,
        fillColor: Color(0x1F767680),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0x1F767680), width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0x1F767680), width: 0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0x1F767680), width: 0),
        ),
      ),
      // フィールドのテキストが変更される度に呼び出される
      onChanged: (value) {
        print('onChanged: $value');
        setState(() {
          onChangedText = value;
        });
      },
      // ユーザーがフィールドのテキストの編集が完了したことを示したときに呼び出される
      onFieldSubmitted: (value) {
        print('onFieldSubmitted: $value');
        setState(() {
          onFieldSubmittedText = value;
        });
      },
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
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: _textField(),
            ),
          ),
          const Divider(height: 0.5),
          SizedBox(
            height: 8,
            child: Container(
              color: Colors.white,
            ),
          ),
          FutureBuilder<List<Article>>(
            future: API().fetchArticle(searchText: onFieldSubmittedText),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return _listView(snapshot.data!);
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          '検索にマッチする記事はありませんでした',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 17),
                        Text(
                          '検索条件を変えるなどして再度検索をしてください',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF828282),
                          ),
                        )
                      ]),
                );
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
