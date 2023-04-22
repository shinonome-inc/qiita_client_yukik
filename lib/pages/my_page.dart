import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qiita_client_yukik/models/user.dart';
import 'package:qiita_client_yukik/pages/feed_detail.dart';
import 'package:qiita_client_yukik/pages/my_page_notlogin.dart';
import 'package:qiita_client_yukik/services/access_token.dart';
import 'package:qiita_client_yukik/ui_components/app_bar_component.dart';
import 'package:qiita_client_yukik/ui_components/follow_counts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var isLoading = false;
  var hasError = false;
  var pageNumbers = 0;
  ScrollController? scrollController;
  var fetchedUsersArticles = [];
  bool accessTokenIsSaved = false;
  bool fetchedAuthenticatedUser = false;
  late User authenticatedUser;
  String accessToken = '';

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController!.addListener(_scrollListener);
    Future(() async {
      await setUpAccessToken();
      await fetchFunction();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  Future<void> setUpAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fetchedAccessToken = prefs.getString('token') ?? "";
    final isSaved = fetchedAccessToken != "";

    setState(() {
      accessTokenIsSaved = isSaved;
      accessToken = fetchedAccessToken;
    });
  }

  void _scrollListener() async {
    if (scrollController != null) {
      double positionRate =
          scrollController!.offset / scrollController!.position.maxScrollExtent;
      const threshold = 0.9;
      if (positionRate > threshold && !isLoading) {
        fetchFunction();
      }
    }
  }

  Future<void> fetchFunction() async {
    if (accessTokenIsSaved && !isLoading) {
      setState(() {
        isLoading = true;
        pageNumbers++;
      });
      final newArticles =
          await AccessToken().fetchUsersArticle(pageNumbers, accessToken);
      authenticatedUser =
          await AccessToken().fetchAuthenticatedUser(accessToken);
      if (mounted) {
        setState(() {
          fetchedUsersArticles.addAll(newArticles);
          isLoading = false;
          fetchedAuthenticatedUser = true;
        });
      }
    }
  }

  Widget _listView(List<dynamic> items) {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: isLoading ? items.length + 1 : items.length,
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
                        '@${authenticatedUser.userId}'
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
    return fetchedAuthenticatedUser
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: const AppBarComponent(title: 'MyPage'),
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
                              NetworkImage(authenticatedUser.imgUrl),
                          radius: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          authenticatedUser.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${authenticatedUser.userId}',
                          style: const TextStyle(
                              color: Color(0xFF828282), fontSize: 12),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          authenticatedUser.description,
                          style: const TextStyle(
                              color: Color(0xFF828282), fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            FollowCounts(
                              count: authenticatedUser.followees,
                              isFollowers: false,
                            ),
                            FollowCounts(
                              count: authenticatedUser.followers,
                              isFollowers: true,
                            ),
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
                        : fetchedUsersArticles.isEmpty
                            ? Container(
                                color: Colors.white,
                              )
                            : isLoading && pageNumbers == 1
                                ? _loadingView()
                                : _listView(fetchedUsersArticles),
                  ),
                ),
              ],
            ))
        : isLoading
            ? _loadingView()
            : const MyPageNotLogin();
  }
}
