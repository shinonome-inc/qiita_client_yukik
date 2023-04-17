import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_client_yukik/models/user.dart';
import 'package:qiita_client_yukik/models/users_article.dart';
import 'package:qiita_client_yukik/pages/feed_detail.dart';
import 'package:qiita_client_yukik/pages/my_page_notlogin.dart';
import 'package:qiita_client_yukik/services/access_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var _isLoading = false;
  var hasError = false;
  var _pageNumbers = 0;
  ScrollController? _scrollController;
  final List<UsersArticle> _fetchedUsersArticles = [];
  bool accessTokenIsSaved = false;
  late User _authenticatedUser;

  @override
  void initState() {
    _scrollController = ScrollController();
    fetchFunction();
    _scrollController!.addListener(_scrollListener);
    super.initState();
    tokenExistence();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  static Future<String?> readToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('token');
    return accessToken;
  }

  static Future<bool> _accessTokenIsSaved() async {
    final accessToken = await readToken();
    return accessToken != null;
  }

  void tokenExistence() async {
    accessTokenIsSaved = await _accessTokenIsSaved();
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
      final newArticles =
          await AccessToken().fetchUsersArticle(page: _pageNumbers);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('token');
      _authenticatedUser =
          await AccessToken().fetchAuthenticatedUser(accessToken);
      if (mounted) {
        setState(() {
          _fetchedUsersArticles.addAll(newArticles);
          _isLoading = false;
        });
      }
    }
  }

  Widget _listView(List<UsersArticle> items) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Row(
              children: [
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
                        '@${_authenticatedUser.userId}'
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
    return accessTokenIsSaved
        ? Scaffold(
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
            body: Column(
              children: [
                const Divider(height: 0.5),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 23, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(_authenticatedUser.imgUrl),
                          radius: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _authenticatedUser.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${_authenticatedUser.userId}',
                          style: const TextStyle(
                              color: Color(0xFF828282), fontSize: 12),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          _authenticatedUser.description,
                          style: const TextStyle(
                              color: Color(0xFF828282), fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${_authenticatedUser.followees}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              ' フォロー中　',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF828282),
                              ),
                            ),
                            Text(
                              '${_authenticatedUser.followers}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              ' フォロワー',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                        : _fetchedUsersArticles.isEmpty
                            ? Container(
                                color: Colors.white,
                              )
                            : _isLoading && _pageNumbers == 1
                                ? _loadingView()
                                : Column(
                                    children: [
                                      _listView(_fetchedUsersArticles),
                                    ],
                                  ),
                  ),
                )
              ],
            ))
        : _isLoading
            ? _loadingView()
            : const MyPageNotLogin();
  }
}
