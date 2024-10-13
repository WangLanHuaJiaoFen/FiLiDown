import 'dart:async';
import 'package:filidown/settings/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget{
  const DownloadPage({
    super.key
  });

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  // TextField的controller，bbdown的路径，视频号，
  // 下载输出，Shell的controller，stdout输出流
  final TextEditingController _controller = TextEditingController();
  final List<String> _output = [];
  ShellLinesController? _shellLinesController;
  late StreamSubscription<String>? _stdoutSubscription;
  Flushbar? failureFlushbar;
  Flushbar? downloadingOverBar;
  List<String> params = [];
  bool isDownloading = false;


  // 释放资源
  @override
  void dispose() {
    _controller.dispose();
    _shellLinesController?.close();
    super.dispose();
  }

  void _submitBvcode() async {
    var appState = context.watch<SettingState>();
    String exePath = appState.retBBDownPath();
    final bvCode = _controller.text;
    if (bvCode.isNotEmpty) {
      setState(() {
        // 清空输出
        isDownloading = true;
        _output.clear();
      });

      getParams(bvCode);

      try {
        // 启动进程
        _shellLinesController = ShellLinesController();
        // 创建shell和监听输出
        var shell = Shell(stdout: _shellLinesController!.sink, stderr: _shellLinesController!.sink);
        _stdoutSubscription = _shellLinesController!.stream.listen((line) {
        setState(() {
          _output.add(line);
        });
      });

        await shell.run('$exePath ${params.join(' ')}')
                                // ignore: body_might_complete_normally_catch_error
                                .catchError((error) {
                                  setState(() {
                                    _output.add("Shell程序非正常结束, 请检查bv号是否正确");
                                  });
                                });
      } catch (e) {
        setState(() {
          _output.add('Failed to start process: $e');
        });
      } finally {
        // 取消订阅，检查是否为空
        setState(() {
          isDownloading = false;
        });

        if (mounted) {
          if (downloadingOverBar == null || downloadingOverBar!.isDismissed() == true) {
            downloadingOverBar = Flushbar(
              messageText: const Text(
                "下载结束，请在输出中检查是否下载成功", 
                style: TextStyle(
                        fontFamily: 'NotoSansSC', 
                        fontSize: 18
                       ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primaryFixedDim, 
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              boxShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  spreadRadius: 1, 
                  blurRadius: 5, 
                  offset: const Offset(0, 2),
                )
              ],
              margin: const EdgeInsets.all(25), 
              duration: const Duration(seconds: 1), 
              isDismissible: true, 
              flushbarPosition: FlushbarPosition.TOP,
            );
            downloadingOverBar!.show(context);
          }
        }
        await _stdoutSubscription?.cancel();
      }
      // 清除资源
      _controller.clear();
    } else {
      if (failureFlushbar == null || failureFlushbar!.isDismissed() == true) {
        failureFlushbar = Flushbar(
          messageText: const Text(
            "输入框不能为空", 
            style: TextStyle(
                    fontFamily: 'NotoSansSC', 
                    fontSize: 18
                   ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryFixedDim, 
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), 
              spreadRadius: 1, 
              blurRadius: 5, 
              offset: const Offset(0, 2),
            )
          ],
          margin: const EdgeInsets.all(25), 
          duration: const Duration(seconds: 1), 
          isDismissible: true, 
          flushbarPosition: FlushbarPosition.TOP,
        );
        failureFlushbar!.show(context);
      }
    }
  }

  Future<void> getParams(String bvCode) async {
    var appState = context.watch<SettingState>();
    params.clear();
    
    params.add(bvCode);
    
    params.add(appState.retDownloadPath());

    params.add(appState.retFFMPEGPath());
    
    params.add(appState.retARIA2CPath());

    params.add(appState.retMP4BOXPath());

    params.add(appState.retHuaZhiChoice());
    params.add(appState.retBianMaChoice());
    params.add(appState.retContentChoice());

    params.add(appState.retCookie());

    params.add(appState.retParseParam());
    params.add(appState.retIsAllStreamParam());
    params.add(appState.retDebugLogParam());

    params.add(appState.retSkipParam());

    params.add(appState.retPRange());
    params.add(appState.retInterval());
    params.add(appState.retAllPName());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "输入av/bv/BV/ep/ss号或者视频地址", 
                      labelStyle: const TextStyle(
                        fontFamily: 'NotoSansSC', 
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                      ),
                      suffixIcon: isDownloading
                        ? Transform.scale(
                          scale: 0.7, 
                          child: const CircularProgressIndicator(strokeWidth: 3.0,),
                        )
                        : IconButton(
                            iconSize: 30.0,
                            onPressed: _submitBvcode, 
                            icon: const Icon(Icons.download_rounded)
                          ), 
                        
                    ),
                    
                    controller: _controller, 
                    onSubmitted: (value) {
                      _submitBvcode();
                    },
                  ),
                );
              }
            ),
            const SizedBox(
              height: 15,
            ), 
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: _output.map((line) => Text(line, style: const TextStyle(fontFamily: 'NotoSansSC'),)).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}