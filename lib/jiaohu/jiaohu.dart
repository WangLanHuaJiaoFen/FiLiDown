import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jiaohu extends StatefulWidget {
  const Jiaohu({
    super.key
  });

  @override
  State<Jiaohu> createState() => _JiaohuState();
}

class _JiaohuState extends State<Jiaohu> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0)
        ), 
        const Center(
          child: Text(
            "交互选项", 
            style: TextStyle(
              fontFamily: 'NotoSansSC',
              fontSize: 30
            )
          ),
        ),
        Row(
          children: [
            Switch(
              value: appState.onlyParse, 
              onChanged: (value) {
                setState(() {
                  appState.onlyParse = value;
                });
              }),
              const Expanded(
                child: Text(
                  "仅解析而不进行下载", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                  )
                )
              ),
          ],
        ), 
        Row(
          children: [
            Switch(
              value: appState.notAllStream, 
              onChanged: (value) {
                setState(() {
                  appState.notAllStream = value;
                });
              }),
              const Expanded(
                child: Text(
                  "不显示所有可用音视频流", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                  )
                )
              ),
          ],
        ), 
        Row(
          children: [
            Switch(
              value: appState.outputDebugLog, 
              onChanged: (value) {
                setState(() {
                  appState.outputDebugLog = value;
                });
              }),
              const Expanded(
                child: Text(
                  "输出调试日志", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                  )
                )
              ),
          ],
        ), 
        const Divider(
        indent: 20,
        endIndent: 20,
        height: 20,
        ) 
      ],
    );
  }
}