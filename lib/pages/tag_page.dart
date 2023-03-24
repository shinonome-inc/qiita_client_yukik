import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/models/fetchTag.dart';
import 'package:qiita_client_yukik/models/tag.dart';

class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);
  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Future<List<Tag>> futureTag;
  var _isLoading = true;
  var _pageNumbers = 1;
  int pageWidth = 2;
  ScrollController? _scrollController;
  final List<Tag> _fetchedTags = [];

  @override
  void initState() {
    super.initState();
    futureTag = ApiTag().fetchTag(page: _pageNumbers);
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
          final newArticles = await ApiTag().fetchTag(page: _pageNumbers);
          setState(() {
            _fetchedTags.addAll(newArticles);
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

  Widget _listTag(List<Tag> tags) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: GridView.builder(
          itemCount: tags.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).size.width / (138 + 16)).toInt()),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                height: 138,
                width: 162,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Image.network(
                      tags[index].iconUrl,
                      width: 38,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      tags[index].tagId,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '投稿件数：${tags[index].itemsCount.toString()}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF828282)),
                    ),
                    Text(
                      'フォロワー数：${tags[index].followersCount}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tags',
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
            FutureBuilder<List<Tag>>(
              future: futureTag,
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.connectionState == ConnectionState.done &&
                    _isLoading) {
                  print('通信完了');
                  _isLoading = false;
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  _pageNumbers += 1;
                  _fetchedTags.addAll(snapshot.data!);
                  return _listTag(_fetchedTags);
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
                return _loadingView();
              },
            ),
          ],
        ));
  }
}
