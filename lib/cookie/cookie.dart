import 'package:filidown/cookie/cookie_input.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Cookie extends StatefulWidget {
  const Cookie({
    super.key
  });

  @override
  State<Cookie> createState() => _CookieState();
}

class _CookieState extends State<Cookie> {

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
            "cookie设置", 
            style: TextStyle(
              fontFamily: 'NotoSansSC', 
              fontSize: 30, 
              fontWeight: FontWeight.w400
            )
          ),
        ), 
        const Center(
          child: Text(
            "cookie具有时效性, 故需要及时更新", 
            style: TextStyle(
              fontFamily: 'NotoSansSC', 
              fontSize: 18
            ),
          ),
        ),
        Row(
          children: [
            Switch(
              value: appState.usingCookie, 
              onChanged: (value) {
                setState(() {
                  appState.usingCookie = value;
                });
              }
            ),
            const Expanded(
              child: Text(
                "是否使用cookie", 
                style: TextStyle(
                  fontFamily: 'NotoSansSC', 
                  fontSize: 16
                )
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/cookie.svg', 
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const CookieInput(judge: 0)));
                  }, 
                  label: const Text(
                    "点击输入cookie",
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16
                    ),
                  )
                ),
            ), 
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/token.svg', 
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const CookieInput(judge: 1)));
                  }, 
                  label: const Text(
                    "点击输入access_token", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16
                    ),
                  )
                ),
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