import 'package:filidown/cookie/cookie.dart';
import 'package:filidown/jiaohu/jiaohu.dart';
import 'package:filidown/skip/skip.dart';
import 'package:flutter/material.dart';

class OtherSettingsPage extends StatelessWidget {
  const OtherSettingsPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Cookie(), 
        Jiaohu(), 
        Skip(), 
      ],
    );
  }
}