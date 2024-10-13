import 'package:filidown/my_home_page.dart';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SettingState>();
    return MaterialApp(
      title: 'FiLiDown',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appState.themeColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
