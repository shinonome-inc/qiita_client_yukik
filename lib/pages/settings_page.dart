import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qiita_client_yukik/constants/privacy_policy.dart';
import 'package:qiita_client_yukik/constants/terms_of_service.dart';
import 'package:qiita_client_yukik/pages/top_page.dart';
import 'package:qiita_client_yukik/ui_components/app_bar_component.dart';
import 'package:qiita_client_yukik/ui_components/settings_item.dart';
import 'package:qiita_client_yukik/ui_components/settings_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool hasError = false;
  String version = '';
  late SharedPreferences? prefs;
  bool accessTokenIsSaved = false;

  @override
  void initState() {
    Future(() async {
      await setAccessToken();
      await getVersion();
    });
    super.initState();
  }

  Future<void> setAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fetchedAccessToken = prefs.getString('token') ?? "";
    final isSaved = fetchedAccessToken != "";

    setState(() {
      accessTokenIsSaved = isSaved;
    });
  }

  Widget logOut() {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
      },
      child: const SettingsItem(
        title: 'ログアウトする',
      ),
    );
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: const AppBarComponent(title: 'Settings'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 0.5),
          SizedBox(
            height: 32,
            child: Container(
              color: const Color(0xffFAFAFA),
            ),
          ),
          const Text(
            '　アプリ情報',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff828282),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SettingsItem(
              title: 'プライバシーポリシー',
              data: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SettingsModal(
                          title: 'プライバシーポリシー',
                          sentence: PrivacyPolicy().privacyText);
                    });
              }),
          SettingsItem(
              title: '利用規約',
              data: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SettingsModal(
                          title: '利用規約', sentence: TermsOfService().termsText);
                    });
              }),
          SettingsItem(
            title: 'アプリバージョン',
            data: Text('v$version'),
          ),
          const SizedBox(
            height: 36,
          ),
          if (accessTokenIsSaved)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '　その他',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff828282),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SettingsItem(
                  title: 'ログアウトする',
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('token');
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TopPage()),
                    );
                  },
                )
              ],
            ),
        ],
      ),
    );
  }
}
