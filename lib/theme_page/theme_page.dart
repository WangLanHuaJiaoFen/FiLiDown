import 'package:filidown/settings/setting_state.dart';
import 'package:filidown/theme_page/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({
    super.key
  });

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
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
            "主题选择", 
            style: TextStyle(
              fontFamily: 'NotoSansSC', 
              fontSize: 30, 
              fontWeight: FontWeight.w400
            ),
          ),
        ), 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...appState.colors.keys.map((String key) {
              return RadioListTile<Color>(
                title: Text(
                  key, 
                  style: const TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16
                  )
                ),
                value: appState.colors[key]!, 
                groupValue: appState.getCurrentColor(), 
                onChanged: (Color? value) {
                  setState(() {
                    appState.changeColor(value!);
                    appState.saveColor();
                  });
                });
            })
          ],
        ), 
        const Divider(
          indent: 20,
          endIndent: 20,
          height: 20,
        ), 
        const Background(), 
      ],
    );
  }
}