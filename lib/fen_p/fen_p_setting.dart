import 'package:filidown/fen_p/fen_p_input_page.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FenPSetting extends StatefulWidget {
  const  FenPSetting({
    super.key
  });

  @override
  State<FenPSetting> createState() => _FenPSettingState();
}

class _FenPSettingState extends State<FenPSetting> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0)
        ),
        const Center(
          child: Text(
            "分P设置", 
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
              value: appState.specificP, 
              onChanged: (value) {
                setState(() {
                  appState.specificP = value;
                });
              }
            ), 
            const Expanded(
              child: Text(
                "手动指定分P", 
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
                  'assets/zd.svg', 
                  width: 20,
                  height: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const FenPInputPage(judge: 0,)),
                  );
                }, 
                label: const Text(
                  "点击输入分P范围",
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16
                  )
                )
              ), 
            )
          ],
        ), 
        Row(
          children: [
            Switch(
              value: appState.needPInterval, 
              onChanged: (value) {
                setState(() {
                  appState.needPInterval = value;
                });
              }
            ), 
            const Expanded(
              child: Text(
                "设置分P下载时间间隔", 
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
                  'assets/interval.svg', 
                  width: 20,
                  height: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const FenPInputPage(judge: 1,)),
                  );
                }, 
                label: const Text(
                  "点击输入时间间隔", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16
                  )
                )
              ), 
            )
          ],
        ), 
        Row(
          children: [
            Switch(
              value: appState.showAllPname, 
              onChanged: (value) {
                setState(() {
                  appState.showAllPname = value;
                });
              }
            ), 
            const Expanded(
              child: Text(
                "展示所有分P标题", 
                style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16
                  )
              )
            ),
          ],
        ), 
      ],
    );
  }
}