import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/models/tag.dart';
import 'package:qiita_client_yukik/pages/error_page.dart';
import 'package:qiita_client_yukik/pages/tag_detail.dart';
import 'package:qiita_client_yukik/root.dart';
import 'package:qiita_client_yukik/services/fetch_tag.dart';
import 'package:qiita_client_yukik/ui_components/app_bar_component.dart';

class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);
  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Future<List<Tag>> futureTag;
  var _isLoading = false;
  var _pageNumbers = 0;
  var hasError = false;
  ScrollController? _scrollController;
  final List<Tag> _fetchedTags = [];
  List<Tag> newTags = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    fetchFunction();
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
        fetchFunction();
      }
    }
  }

  void fetchFunction() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _pageNumbers++;
      });

      try {
        newTags = await ApiTag().fetchTag(page: _pageNumbers);
      } catch (e) {
        setState(() {
          hasError = true;
        });
      } finally {
        setState(() {
          _fetchedTags.addAll(newTags);
          _isLoading = false;
        });
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
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: GridView.builder(
        controller: _scrollController,
        itemCount: tags.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width ~/ 178),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              String tagName = tags[index].tagId;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TagDetail(tagName: tagName)));
            },
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
                    errorBuilder: (c, o, s) {
                      return const SizedBox(
                        height: 38,
                      );
                    },
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
                    '投稿件数：${tags[index].itemsCount}',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF828282)),
                  ),
                  Text(
                    'フォロワー数：${tags[index].followersCount}',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF828282)),
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
        backgroundColor: Colors.white,
        appBar: const AppBarComponent(title: 'Tags'),
        body: Column(
          children: [
            const Divider(height: 0.5),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Center(
                  child: hasError
                      ? ErrorPage(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Root(page: 1)));
                          },
                        )
                      : _isLoading && _pageNumbers == 1
                          ? _loadingView()
                          : _listTag(_fetchedTags)),
            )
          ],
        ));
  }
}
