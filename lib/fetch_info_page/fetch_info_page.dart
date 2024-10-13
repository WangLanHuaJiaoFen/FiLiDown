import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FetchInfoPage extends StatefulWidget {

  const FetchInfoPage({
    super.key
  });

  @override
  State<FetchInfoPage> createState() => _FetchInfoPageState();
}

class _FetchInfoPageState extends State<FetchInfoPage> {
  final TextEditingController _controller = TextEditingController();
  Flushbar? commonFlushbar;
  final String apiUrl = "https://api.bilibili.com/x/web-interface/card?mid=";

  void showFlushbar(String info) {
    // 调用显示flushbar的接口
    if (commonFlushbar == null) {
      commonFlushbar = Flushbar(
        messageText: Text(
          info, 
          style: const TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 18
                  )
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim, 
        borderRadius: const BorderRadius.all(Radius.circular(12.0)), 
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            spreadRadius: 1, 
            blurRadius: 5, 
            offset: const Offset(0, 2),
          )
        ],
        margin: const EdgeInsets.all(25), 
        duration: const Duration(seconds: 1), 
        isDismissible: true, 
        flushbarPosition: FlushbarPosition.TOP,
      );
      commonFlushbar!.show(context);
    }
    // 清空
    commonFlushbar = null;
  }

  Future<void> getUserInfo() async {
    final String inputUrl = _controller.text;
    try {
      if (inputUrl.isNotEmpty) {
        // 获取mid
        RegExp regExp = RegExp(r'\/(\d+)');
        Match? match = regExp.firstMatch(inputUrl);
        
        if (match != null) {
          // 发送请求
          String mid = match.group(1)!;
          String requestUrl = apiUrl + mid;
          final response = await http.get(Uri.parse(requestUrl));

          if (response.statusCode == 200) {
            //请求成功
            Map<String, dynamic> userData = jsonDecode(response.body);
            
            setState(() {
              var appState = context.watch<SettingState>();
              appState.updateInfo(
                userData['data']['card']['face'], 
                userData['data']['card']['name'], 
                userData['data']['card']['sign']
              );
              appState.notify();
            });
            showFlushbar("用户信息获取成功");
            _controller.clear();
          } else {
            // 请求失败
            showFlushbar("请求失败, 请检查输入的URL");
          }
        } else {
          // 输入有误
          showFlushbar("输入有误, 没有检测到用户id");
        }
      } else {
        // 输入为空
        showFlushbar("输入框不能为空");
      }
    } catch (e) {
      showFlushbar("发生意外错误");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();
    var colorScheme = Theme.of(context).colorScheme;

    var mainArea = ColoredBox(
        color: (appState.useBackgroundImage == true) 
             ? Colors.transparent
             : colorScheme.primaryContainer,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0), 
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.8, 
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "请输入你的哔哩哔哩个人空间URL: eg: https://space.bilibili.com/95905761?spm_id_from=333.1007.0.0", 
                            labelStyle: const TextStyle(
                              fontFamily: 'NotoSansSC'
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                            ), 
                            suffixIcon: IconButton(
                              onPressed: () {
                                getUserInfo();
                              }, 
                              icon: const Icon(Icons.check_rounded)), 
                          ),
                          controller: _controller, 
                          onSubmitted: (value) {
                            getUserInfo();
                          },
                        ),
                      );
                    }),
                  ),
              )
            )
          ],
        )
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
      appBar: AppBar(
        title: const Text(
          "获取信息", 
          style: TextStyle(
            fontFamily: 'NotoSansSC', 
            fontSize: 25
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: appState.useBackgroundImage == true ? true : false,
      body: (appState.useBackgroundImage == true)
            ? Stack(
                children: [
                  Positioned.fill(
                    child: imageArea
                  ), 
                  SafeArea(
                    child: mainArea
                  )
                ],
              )
            : mainArea
    );
  }
}