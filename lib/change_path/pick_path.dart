import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PickPath extends StatefulWidget {
  const PickPath({
    super.key
  });

  @override
  State<PickPath> createState() => _PickPathState();
}

class _PickPathState extends State<PickPath> {
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
              "目录设置", 
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
                value: appState.useMp4box, 
                onChanged: (value) {
                  setState(() {
                    appState.useMp4box = value;
                    appState.saveAMChoice();
                  });
                }
              ), 
              const Expanded(
                child: Text(
                  "使用mp4box", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
                )
              )
            ],
          ), 
          Row(
            children: [
              Switch(
                value: appState.useAria2c, 
                onChanged: (value) {
                  setState(() {
                    appState.useAria2c = value;
                    appState.saveAMChoice();
                  });
                }
              ), 
              const Expanded(
                child: Text(
                  "使用aria2c", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
                )
              )
            ],
          ), 
          Row(
            children: [
              const Text(
                  "当前下载目录:", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
              ),
              Expanded(
                child: Center(
                  child: Text(
                    appState.downloadPath, 
                    style: const TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  ),
                ),
              ), 
              Padding(
                padding: const EdgeInsets.all(8.0), 
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                          './assets/path.svg',
                          width: 20,
                          height:20
                        ),
                  onPressed: () {
                    setState(() {
                      appState.pickDirectory();
                      appState.notify();
                    });
                  }, 
                  label: const Text(
                      "选择其他目录", 
                      style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  )
                ),
              )
            ],
          ), 
          Row(
            children: [
              const Text(
                  "当前bbdown目录:", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
                ), 
              Expanded(
                child: Center(
                  child: Text(
                    appState.bbdownPath, 
                    style: const TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  ),
                )
              ), 
              Padding(
                padding: const EdgeInsets.all(8.0), 
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                          './assets/path.svg',
                          width: 20,
                          height:20
                        ),
                  onPressed: () {
                    setState(() {
                      appState.pickFile(0);
                      appState.notify();
                    });
                  }, 
                  label: const Text(
                    "选择其他文件", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  )
                ),
              )
            ],
          ), 
          Row(
            children: [
              const Text(
                  "当前ffmpeg目录:", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
              ),
              Expanded(
                child: Center(
                  child: Text(
                    appState.ffmpegPath, 
                    style: const TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  ),
                )
              ), 
              Padding(
                padding: const EdgeInsets.all(8.0), 
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                          './assets/path.svg',
                          width: 20,
                          height:20
                        ),
                  onPressed: () {
                    setState(() {
                      appState.pickFile(1);
                      appState.notify();
                    });
                  }, 
                  label: const Text(
                    "选择其他文件", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  )
                ),
              )
            ],
          ), 
          Row(
            children: [
              const Text(
                  "当前aria2c目录:", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
              ), 
              Expanded(
                child: Center(
                  child: Text(
                    appState.aria2cPath, 
                    style: const TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0), 
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                          './assets/path.svg',
                          width: 20,
                          height:20
                        ),
                  onPressed: () {
                    setState(() {
                      appState.pickFile(2);
                      appState.notify();
                    });
                  }, 
                  label: const Text(
                    "选择其他文件", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  )
                ),
              )
            ],
          ), 
          Row(
            children: [
              const Text(
                  "当前mp4box目录:", 
                  style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 16,
                  )
              ), 
              Expanded(
                child: Center(
                  child: Text(
                    appState.mp4boxPath, 
                    style: const TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0), 
                child: ElevatedButton.icon(
                  icon: SvgPicture.asset(
                          './assets/path.svg',
                          width: 20,
                          height:20
                        ),
                  onPressed: () {
                    setState(() {
                      appState.pickFile(3);
                      appState.notify();
                    });
                  }, 
                  label: const Text(
                    "选择其他文件", 
                    style: TextStyle(
                      fontFamily: 'NotoSansSC', 
                      fontSize: 16,
                    )
                  )
                ),
              )
            ],
          ), 
      ],
    );
  }
}