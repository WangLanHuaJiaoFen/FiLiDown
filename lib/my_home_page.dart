import 'dart:io';

import 'package:filidown/change_path/pick_path_page.dart';
import 'package:filidown/download_page.dart';
import 'package:filidown/fen_p/fen_p_setting.dart';
import 'package:filidown/login_page/login_page.dart';
import 'package:filidown/other_settings/other_settings_page.dart';
import 'package:filidown/settings/setting_page.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:filidown/theme_page/theme_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _seletedIndex = 0;
  final List<String> titles = [
    "下载页面",
    "登录页面",
    "下载设置",
    "目录设置",  
    "主题设置", 
    "分P设置",
    "其他设置(本页面设置选项退出软件后不会保存)"
  ];

  void changeSeletedIndex(int index) {
    setState(() {
      _seletedIndex = index;
    });
  }

  ImageProvider<Object> getBackgroundImage(String? faceUrl) {

    if (faceUrl == null) {
      return const AssetImage('assets/akari.jpg');
    } else {
      return NetworkImage(faceUrl);
    }
  }

  String getName(String? userName) {

    if (userName == null) {
      return "未登录用户";
    } else {
      return userName;
    }
  }

  String getSign(String? sign) {

    if (sign == null) {
      return "这个人很神秘, 什么都没有写";
    } else {
      return sign;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? faceUrl = context.select<SettingState, String?>((state) => state.localFaceUrl);
    final String? userName = context.select<SettingState, String?>((state) => state.localUserName);
    final String? sign = context.select<SettingState, String?>((state) => state.localSign);

    var colorScheme = Theme.of(context).colorScheme;
    String pageTitle;
    Widget page;
    switch (_seletedIndex) {
      case 0:
        page = const DownloadPage();
        pageTitle = titles[_seletedIndex];
        break;
      case 1:
        page = const LoginPage();
        pageTitle = titles[_seletedIndex];
        break;
      case 2:
        page = const SettingPage();
        pageTitle = titles[_seletedIndex];
        break;
      case 3:
        page = const PickPathPage();
        pageTitle = titles[_seletedIndex];
        break;
      case 4:
        page = const ThemePage();
        pageTitle = titles[_seletedIndex];
        break;
      case 5:
        page = const FenPSetting();
        pageTitle = titles[_seletedIndex];
      case 6:
        page = const OtherSettingsPage();
        pageTitle = titles[_seletedIndex];
        break;
      default:
        throw UnimplementedError("no index for $_seletedIndex");
    }
    var appState = context.watch<SettingState>();

    var mainArea = ColoredBox(
      color: (appState.useBackgroundImage == true) 
             ? Colors.transparent
             : colorScheme.primaryContainer, 
      child: AnimatedSwitcher(
        duration:const Duration(milliseconds: 500),
        child: page,
      ),
    );

    var imageArea = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (appState.uploadImage == false) 
                 ? AssetImage(appState.imgPath!)
                 : FileImage(File(appState.imgPath!)),
          fit: BoxFit.cover, 
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4), 
            BlendMode.dstATop
          ),
        ), 
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: appState.useBackgroundImage == true ? true : false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          pageTitle, 
          style: const TextStyle(
            fontFamily: 'NotoSansSC', 
            fontSize: 25
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => {
                Scaffold.of(context).openDrawer()
              }, 
              icon: const Icon(Icons.menu_rounded,), 
        );
        })
      ),
      drawer: Drawer(
        elevation: 5,
        backgroundColor: colorScheme.onInverseSurface,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(0.0), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
              ),
              color: colorScheme.primaryFixedDim,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                          radius: 40, 
                          backgroundColor: Colors.transparent, 
                          backgroundImage: getBackgroundImage(faceUrl),
                        ), 
                    const SizedBox(width: 5,), 
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              getName(userName), 
                              style: const TextStyle(
                                fontFamily: 'NotoSansSC', 
                              ),
                            ),
                            subtitle: Text(
                              getSign(sign), 
                              style: const TextStyle(
                                fontFamily: 'NotoSansSC', 
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ), 
            ), 
            ListTile(
              title: Text(
                titles[0], 
                style: const TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 0, 
              onTap: () {
                changeSeletedIndex(0);
                // 退出抽屉
                Navigator.pop(context);
              },
            ), 
            ListTile(
              title: Text(
                titles[1], 
                style: const TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 1, 
              onTap: () {
                changeSeletedIndex(1);
                Navigator.pop(context);
              },
            ), 
            ListTile(
              title: Text(
                titles[2], 
                style: const TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 2, 
              onTap: () {
                changeSeletedIndex(2);
                Navigator.pop(context);
              },
            ), 
            ListTile(
              title: Text(
                titles[3], 
                style: const TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 3, 
              onTap: () {
                changeSeletedIndex(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                titles[4], 
                style: const TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 4, 
              onTap: () {
                changeSeletedIndex(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                titles[5], 
                style: const TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 5, 
              onTap: () {
                changeSeletedIndex(5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "其他设置", 
                style: TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 18
                ),
              ),
              selected: _seletedIndex == 6, 
              onTap: () {
                changeSeletedIndex(6);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ),  
      body: (appState.useBackgroundImage == true)
            ? Stack(
                children: [
                  // 添加背景图片的部分
                  Positioned.fill(
                    child: imageArea, // imageArea应该是一个背景图片的Container
                  ),
                  // 确保内容不与AppBar重叠，添加适当的间距
                  SafeArea(
                    child: Row(
                      children: [
                        Expanded(child: mainArea),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: mainArea)
                ],
              )
    );
  }
}
