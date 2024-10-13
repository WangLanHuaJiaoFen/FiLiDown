import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CookieInput extends StatefulWidget {
  // 判断输入的是什么
  final int judge;


  const CookieInput({
    super.key, 
    required this.judge
  });

  @override
  State<CookieInput> createState() => _CookieInputState();
}

class _CookieInputState extends State<CookieInput> {
    // 0 -c 1 -at
  List<String> lint = ["请输入cookie", "请输入access_token"];
  late int judge;
  final TextEditingController _controller = TextEditingController();
  Flushbar? commonFlushbar;

  @override
  void initState() {
    super.initState();
    judge = widget.judge;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  void setCookie() {
    final String inputCookie = _controller.text;
    if (inputCookie.isNotEmpty) {
      var appState = context.watch<SettingState>();
      // 保证只用一种
      if (judge == 0) {
        // cookie
        appState.cookie = inputCookie;
        appState.cookieInput = true;
        appState.tokenInput = false;
      } else if (judge == 1) {
        // access_token
        appState.accessToken = inputCookie;
        appState.tokenInput = true;
        appState.cookieInput = false;
      }
      showFlushbar("设置成功");
      _controller.clear();
    } else {
      // 输入为空
      showFlushbar("输入框不能为空");
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();
    var colorScheme = Theme.of(context).colorScheme;

    var mainArea =  ColoredBox(
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
                                          labelText: lint[judge], 
                                          labelStyle: const TextStyle(
                                            fontFamily: 'NotoSansSC', 
                                          ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                                          ), 
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setCookie();
                                            }, 
                                            icon: const Icon(Icons.check_rounded)), 
                                        ),
                                      controller: _controller,
                                      onSubmitted: (value) {
                                        setCookie();
                                      },
                                      ),
                                    );
                                  }),
                              ),
                            )
                          )
                        ],
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
      appBar: AppBar(
        title: const Text(
          "输入cookie", 
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