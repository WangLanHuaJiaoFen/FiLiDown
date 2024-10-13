import 'package:filidown/settings/bianma.dart';
import 'package:filidown/settings/download_content.dart';
import 'package:filidown/settings/huazhi.dart';
import 'package:flutter/material.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        HuazhiSetting(), 
        BianmaSetting(), 
        DownloadContent(),
      ]
    );
  }
}