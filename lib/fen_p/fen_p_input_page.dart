import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FenPInputPage extends StatefulWidget {
  // 判断是哪一种
  final int judge;
  const FenPInputPage({
    super.key,
    required this.judge
  });

  @override
  State<FenPInputPage> createState() => _FenPInputPageState();
}

class _FenPInputPageState extends State<FenPInputPage> {
  // 0 范围 1 间隔
  List<String> lint = ["设置分P范围", "设置分P下载间隔"];
  List<String> labelText = ["eg: 8 / 1,2 / 3-5 / ALL / 3,5,LATEST", "单位为秒, eg: 0"];
  final TextEditingController _controller = TextEditingController();
  Flushbar? commonFlushbar;
  late int judge;
  
  void setFenPSetting() {
    final String inputFenPSetting = _controller.text;
    if (inputFenPSetting.isNotEmpty) {
      var appState = context.watch<SettingState>();
      if (judge == 0) {
          // 管理状态
        appState.pRange = inputFenPSetting;
        appState.pRangeInput = true;
      } else if (judge == 1) {
        appState.interval = inputFenPSetting;
        appState.intervalInput = true;
      }
      showFlushbar("设置成功");
      _controller.clear();
    } else {
      // 输入为空
      showFlushbar("输入框不能为空");
    }
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
                                      width: constraints.maxHeight * 0.8,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: labelText[judge], 
                                          labelStyle: const TextStyle(
                                            fontFamily: 'NotoSansSC', 
                                          ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                                          ), 
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setFenPSetting();
                                            }, 
                                            icon: const Icon(Icons.check_rounded)), 
                                        ),
                                        controller: _controller, 
                                        onSubmitted: (value) {
                                          setFenPSetting();
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
        title: Text(
          lint[judge], 
          style: const TextStyle(
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