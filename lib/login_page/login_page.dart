import 'dart:async';

import 'package:filidown/fetch_info_page/fetch_info_page.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 判断是否生成二维码，是否点击生成二维码，是否获取到用户信息
  bool isQrCodeGenerated = false;
  bool isClicked = false;
  ShellLinesController? _shellLinesController;
  StreamSubscription<String>? _stdoutSubscription;
  List<String> params = [];
  Flushbar? commonFlushbar;

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

  @override
  void dispose() {
    _shellLinesController?.close();
    _stdoutSubscription?.cancel();
    super.dispose();
  }

  Future<void> login() async {
    var appState = context.watch<SettingState>();
    String exePath = appState.retBBDownPath();
    try {
      _shellLinesController = ShellLinesController();
      var shell = Shell(stdout: _shellLinesController!.sink, stderr: _shellLinesController!.sink);
      _stdoutSubscription = _shellLinesController!.stream.listen((line) {
        if (line.contains('生成二维码成功')) {
          setState(() {
            isQrCodeGenerated = true;
          });
        }
      });

      await shell.run('$exePath login').whenComplete(() {
        setState(() {
          // 登陆成功
          appState.isProcessComplete = true;
        });
      });
    } catch (e) {
      if (mounted) {
        showFlushbar("登录请求错误");
      }
    } finally {
      await _stdoutSubscription?.cancel();
    }
  }

  Widget _buildQrCodeDisplay() {
    String pngPath = './qrcode.png';
    // isQrCodeGenerated判断是否生成了二维码
    if (!isQrCodeGenerated) {
      return const Text(
        "正在生成二维码...", 
        style: TextStyle(
          fontFamily: 'NotoSansSC'
          ),
        );
    }
    return Image.file(
      File(pngPath), 
      fit: BoxFit.contain
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();

    return Center(
      // appState.isProcessComplete控制展示已登录或者点击登录
      child: appState.isProcessComplete
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "已登录", 
              style: TextStyle(
                fontFamily: 'NotoSansSC',
              ),
            ),
            const Text(
              "你还可以输入你的哔哩哔哩主页，这将可以在侧滑栏展示你的信息", 
              style: TextStyle(
                fontFamily: 'NotoSansSC'
                ),
              ), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FetchInfoPage()));
                  }, 
                  label: const Text(
                    "点击输入", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16
                    ),
                  ), 
                  icon: SvgPicture.asset(
                    'assets/individual.svg', 
                    width: 20, 
                    height: 20,
                  ),
                ), 
                const SizedBox(width: 20,), 
                ElevatedButton.icon(
                  onPressed: () {
                    if (appState.isUserInfoFetched) {
                      setState(() {
                        appState.clearUserInfo();
                        appState.notify();
                        showFlushbar("个人信息已清除");
                      });
                    } else {
                      showFlushbar("还未获取个人信息");
                    }
                  }, 
                  label: const Text(
                    "清空个人信息", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16
                    ),), 
                  icon: SvgPicture.asset(
                    'assets/cancel.svg', 
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            )
          ],
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // isClicked控制点击后显示二维码
            isClicked ? _buildQrCodeDisplay() : const SizedBox(),  
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (!isClicked) {
                    isClicked = true;
                    login();
                  }
                });
              }, 
              label: const Text("点击登录"), 
              icon: SvgPicture.asset(
                'assets/bilibili.svg', 
                width: 20,
                height: 20,
              ),
            )
          ],
        )
    );
  }
}