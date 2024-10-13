import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Background extends StatefulWidget {
  const Background({
    super.key
  });

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0), 
        ), 
        const Center(
          child: Text(
            "背景图片", 
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
              value: appState.useBackgroundImage, 
              onChanged: (value) {
                setState(() {
                  appState.useBackgroundImage = value;
                  appState.saveBgSetting();
                  // 更新
                  appState.notify();
                });
              }
            ), 
            const Expanded(
              child: Text(
                "使用背景图片", 
                style: TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 16
                )
              )
            ), 
            Padding(
              padding: const EdgeInsets.all(8.0), 
              child: ElevatedButton.icon(
                icon: SvgPicture.asset(
                  'assets/uploadImg.svg', 
                  width: 20,
                  height: 20,
                ),
                onPressed: () {
                  setState(() {
                    appState.pickImg();
                  });
                }, 
                label: const Text(
                  "上传图片", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16
                  ),
                )
              ),
            ), 
          ],
        )
      ],
    );
  }
}