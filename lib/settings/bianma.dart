import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BianmaSetting extends StatefulWidget {
  const BianmaSetting({
    super.key
  });

  @override
  State<BianmaSetting> createState() => _BianmaSettingState();
}

class _BianmaSettingState extends State<BianmaSetting> {
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
            "视频编码", 
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
            ...appState.bianMaChoices.keys.map((String key) {
              return RadioListTile(
                title: Text(
                  appState.bianMaChoices[key]!, 
                  style: const TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                  )
                ),
                value: appState.bianMaChoices[key]!, 
                groupValue: appState.getCurrentBianMa(), 
                onChanged: (String? value) {
                  setState(() {
                    appState.changeBianMa(value!);
                    appState.saveBianMaChoice();
                  });
                });
            })
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