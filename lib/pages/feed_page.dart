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
  var _isLoading = true;
  var _pageNumbers = 0;
  ScrollController? _scrollController;
  List<Article> _fetchedArticles = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    futureArticle = API().fetchArticle();
    _scrollController!.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController != null) {
      double positionRate = _scrollController!.offset /
          _scrollController!.position.maxScrollExtent;
      const threshold = 0.9;
      if (positionRate > threshold && !_isLoading) {
        setState(() {
          _isLoading = true;
        });
        try {
          final newArticles = await API().fetchArticle(
              searchText: onFieldSubmittedText, page: _pageNumbers);
          setState(() {
            _fetchedArticles.addAll(newArticles);
            _pageNumbers++;
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _listView(List<Article> items) {
    print('表示件数： ${items.length}');
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _isLoading ? items.length + 1 : items.length,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _loadingView();
          }
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
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 12, 12, 10),
        hintStyle: const TextStyle(
          color: Color(0x993C3C43),
          fontSize: 17,
        ),
        filled: true,
        fillColor: const Color(0x1F767680),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1F767680), width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1F767680), width: 0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1F767680), width: 0),
        ),
      ),
      // フィールドのテキストが変更される度に呼び出される
      onChanged: (value) {
        setState(() {
          onChangedText = value;
        });
      },
      // ユーザーがフィールドのテキストの編集が完了したことを示したときに呼び出される
      onFieldSubmitted: (value) {
        setState(() {
          onFieldSubmittedText = value;
          _fetchedArticles.clear();
          _isLoading = true;
          _pageNumbers = 1;
        });
        futureArticle = API()
            .fetchArticle(searchText: onFieldSubmittedText, page: _pageNumbers);
      },
    );
  }

  Widget _loadingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.grey,
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
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
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              future: futureArticle,
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.connectionState == ConnectionState.done &&
                    _isLoading) {
                  print('通信完了');
                  _isLoading = false;
                  _pageNumbers += 1;
                  _fetchedArticles.addAll(snapshot.data!);
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return _listView(_fetchedArticles);
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
        ));
  }
}
