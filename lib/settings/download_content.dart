import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadContent extends StatefulWidget {
  const DownloadContent({
    super.key
  });

  @override
  State<DownloadContent> createState() => _DownloadContentState();
}

class _DownloadContentState extends State<DownloadContent> {
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
            "下载内容选择(弹幕需使用支持导入弹幕的播放器)", 
            style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 30, 
                    fontWeight: FontWeight.w400
                  ) 
          ),
        ), 
        Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            ...appState.contentChoices.keys.map((String key) {
              return RadioListTile(
                title: Text(
                  appState.contentChoices[key]!, 
                  style: const TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                  )
                ),
                value: appState.contentChoices[key]!, 
                groupValue: appState.getCurrentContent(), 
                onChanged: (String? value) {
                  setState(() {
                    appState.changeContent(value!);
                    appState.saveContentChoice();
                  });
                });
            })
          ],
        ), 
      ],
    );
  }
}