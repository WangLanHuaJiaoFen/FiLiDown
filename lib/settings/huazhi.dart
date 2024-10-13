import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HuazhiSetting extends StatefulWidget {
  const HuazhiSetting({
    super.key
  });

  @override
  State<HuazhiSetting> createState() => _HuazhiState();
}

class _HuazhiState extends State<HuazhiSetting> {
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
            "画质选择", 
            style: TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 30, 
                    fontWeight: FontWeight.w400
                  )
          ),
        ), 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...appState.choices.keys.map((String key) {
                return RadioListTile(
                  title: Text(
                    appState.choices[key]!, 
                    style: const TextStyle(
                    fontFamily: 'NotoSansSC',
                    fontSize: 16
                  )
                  ),
                  value: appState.choices[key]!, 
                  groupValue: appState.getCurrentHuaZhi(), 
                  onChanged: (String? value) {
                    setState(() {
                      appState.changeChoice(value!);
                      appState.saveHuaZhiChoice();
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