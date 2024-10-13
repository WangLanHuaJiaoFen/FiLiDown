import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Skip extends StatefulWidget {
  const Skip({
    super.key
  });

  @override
  State<Skip> createState() => _SkipState();
}

class _SkipState extends State<Skip> {
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
            "跳过选项", 
            style: TextStyle(
              fontFamily: 'NotoSansSC',
              fontSize: 30, 
              fontWeight: FontWeight.w400
            )
          ),
        ), 
        Row(
          children: [
            Switch(
              value: appState.skipZimu, 
              onChanged: (value) {
                setState(() {
                  appState.skipZimu = value;
                });
              }
            ),
            const Expanded(
              child: Text(
                "跳过字幕下载", 
                style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                )
              ),
            ),
          ],
        ), 
        Row(
          children: [
            Switch(
              value: appState.skipCover, 
              onChanged: (value) {
                setState(() {
                  appState.skipCover = value;
                });
              }
            ),
            const Expanded(
              child: Text(
                "跳过封面下载", 
                style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                )
              ),
            ),
          ],
        ), 
        Row(
          children: [
            Switch(
              value: appState.skipMixedStream, 
              onChanged: (value) {
                setState(() {
                  appState.skipMixedStream = value;
                });
              }
            ),
            const Expanded(
              child: Text(
                "跳过混流步骤", 
                style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                )
              ),
            ),
          ],
        ), 
      ],
    );
  }
}