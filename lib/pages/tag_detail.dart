import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_client_yukik/models/article.dart';
import 'package:qiita_client_yukik/pages/feed_detail.dart';
import 'package:qiita_client_yukik/services/fetch_tag_detail.dart';

class TagDetail extends StatefulWidget {
  const TagDetail({Key? key, required this.tagName}) : super(key: key);
  final String tagName;

  @override
  State<TagDetail> createState() => _TagDetailState();
}

class _TagDetailState extends State<TagDetail> {
  var _isLoading = false;
  var hasError = false;
  var _pageNumbers = 0;
  ScrollController? _scrollController;
  final List<Article> _fetchedArticles = [];

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

  Future<void> fetchFunction() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _pageNumbers++;
      });
      final newArticles = await ApiTagDetail()
          .fetchTagDetail(page: _pageNumbers, tag: widget.tagName);
      setState(() {
        _fetchedArticles.addAll(newArticles);
        _isLoading = false;
      });
    }
  }

  Widget _listView(List<Article> items) {
    return ListView.builder(
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
          child: Row(
            children: [
              SizedBox(
                width: 38,
                height: 38,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    items[index].users.imgUrl,
                    errorBuilder: (c, o, s) {
                      return const SizedBox(
                        height: 38,
                      );
                    },
                  ),
                ),
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
                      ' 投稿日:${DateFormat('yyyy/MM/dd').format(items[index].createdAt)}'
                      ' いいね:${items[index].likes.toString()}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF828282)),
                    ),
                    const Divider(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.tagName,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pacifico-Regular',
                  fontSize: 17,
                )),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Color(0xFF468300))),
        body: Column(
          children: [
            const Divider(height: 0.5),
            Container(
              height: 28,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFF2F2F2),
              child: const Text(
                '    投稿記事',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff828282),
                ),
              ),
            ),
            Expanded(
              child: Center(
                  child: hasError
                      ? const Text('error')
                      : _isLoading && _pageNumbers == 1
                          ? _loadingView()
                          : _listView(_fetchedArticles)),
            )
          ],
        ));
  }
}
