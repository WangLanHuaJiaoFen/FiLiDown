import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingState extends ChangeNotifier {
  
  SettingState() {
    initState();
  }

  // 初始化状态
  Future<void> initState() async {
    await loadBgSetting();
    await loadUserInfo();
    await loadBianMaChoice();
    await loadContentChoice();
    await loadHuaZhiChoice();
    await loadPath();
    await loadAMChoice();
    await loadColor();
  }
  

  // 画质部分
  // 当前选项
  String? selectedHuaZhi = "优先下载最高画质";
  
  // 选项
  Map<String, String> choices = {
    "0": "优先下载最高画质", 
    "1": "8K 超高清", 
    "2": "杜比视界", 
    "3": "HDR 真彩", 
    "4": "4K 超清", 
    "5": "1080P 高清",
    "6": "1080P 高码率", 
    "7": "720P 高清", 
    "8": "480P 清晰", 
    "9": "360P 流畅"
  };

  // 获取和修改
  String getCurrentHuaZhi() {
    return selectedHuaZhi!;
  } 

  void changeChoice(String value) {
    selectedHuaZhi = value;
  }

  // 返回参数命令
  String retHuaZhiChoice() {
    if (selectedHuaZhi == "优先下载最高画质") {
      return "";
    } else {
      return "-q \"$selectedHuaZhi\"";
    }
  }

  // 保存和加载
  Future<void> saveHuaZhiChoice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('choice', selectedHuaZhi!);
  }

  Future<void> loadHuaZhiChoice() async {
    final prefs = await SharedPreferences.getInstance();
    selectedHuaZhi = prefs.getString('choice') ?? "优先下载最高画质";
  }

  // 编码部分
  // 当前选项
  String? selectedBianMa = "优先可用编码";
  // 选项
  Map<String, String> bianMaChoices = {
    "0": "优先可用编码", 
    "1": "hevc", 
    "2": "av1", 
    "3": "avc"
  };
  
  // 获得和修改
  String getCurrentBianMa() {
    return selectedBianMa!;
  }

  void changeBianMa(String value) {
    selectedBianMa = value;
  }

  // 返回参数命令
  String retBianMaChoice() {
    if (selectedBianMa == "优先可用编码") {
      return "";
    } else {
      return "-e $selectedBianMa";
    }
  }
  
  // 保存和加载
  Future<void> saveBianMaChoice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('bianMaChoice', selectedBianMa!);
  }

  Future<void> loadBianMaChoice() async {
    final prefs = await SharedPreferences.getInstance();
    selectedBianMa = prefs.getString('bianMaChoice') ?? "优先可用编码";
  }

  // 仅下载内容部分
  // 当前选项
  String? selectedContent = "默认下载视频音频和封面";
  // 选项
  Map<String, String> contentChoices = {
    "0": "默认下载视频音频和封面", 
    "1": "下载视频音频封面和弹幕",
    "2": "仅下载视频", 
    "3": "仅下载音频", 
    "4": "仅下载弹幕", 
    "5": "仅下载字幕", 
    "6": "仅下载封面", 
  };

  Map<String, String> contentChoicesCommand = {
    "0": "", 
    "1": "-dd", 
    "2": "--video-only", 
    "3": "--audio-only", 
    "4": "--danmaku-only", 
    "5": "--sub-only", 
    "6": "--cover-only", 
  };

  // 获得和修改
  String getCurrentContent() {
    return selectedContent!;
  }

  void changeContent(String value) {
    selectedContent = value;
  }

  // 返回参数命令
  String retContentChoice() {
    if (selectedContent == "默认下载视频音频和封面") {
      return "";
    } else {
      String param = contentChoices.entries.firstWhere((entry) => entry.value == selectedContent).key;
      return "${contentChoicesCommand[param]}";
    }
  }

  // 保存和加载
  Future<void> saveContentChoice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('contentChoice', selectedContent!);
  }

  Future<void> loadContentChoice() async {
    final prefs = await SharedPreferences.getInstance();
    selectedContent = prefs.getString('contentChoice') ?? "默认下载视频音频和封面";
  }


  // 登录部分
  // 是否登录的信息
  bool isProcessComplete = false;
  // 是否获取到用户信息
  bool isUserInfoFetched = false;


  // 记录头像，昵称和签名等相关信息
  String? localFaceUrl;
  String? localUserName;
  String? localSign;
  
  // 更新信息
  Future<void> updateInfo(String faceUrl, String userName, String sign) async {
    localFaceUrl = faceUrl;
    localUserName = userName;
    localSign = sign;
    isUserInfoFetched = true;
    ChangeNotifier();
    await saveUserInfo();
  }

  // 保存和加载用户登录信息
  Future<void> saveUserInfo() async {
    // 只在既登录又输入了个人信息才进行保存
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('faceUrl', localFaceUrl!);
    prefs.setString('userName', localUserName!);
    prefs.setString('sign', localSign!);
    prefs.setBool('isProcessComplete', isProcessComplete);
    prefs.setBool('isUserInfoFetched', isUserInfoFetched);
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    localFaceUrl = prefs.getString('faceUrl');
    localUserName = prefs.getString('userName');
    localSign = prefs.getString('sign');
    isProcessComplete = prefs.getBool('isProcessComplete') ?? false;
    isUserInfoFetched = prefs.getBool('isUserInfoFetched') ?? false;
    notifyListeners();
  }
  // 清空个人信息
  Future<void> clearUserInfo() async {
    localFaceUrl = null;
    localUserName = null;
    localSign = null;
    isProcessComplete = false;
    isUserInfoFetched = false;
    ChangeNotifier();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('faceUrl');
    prefs.remove('userName');
    prefs.remove('sign');
    prefs.remove('isProcessComplete');
    prefs.remove('isUserInfoFetched');
  }

  // cookie部分
  // 是否输入
  bool cookieInput = false;
  bool tokenInput = false;

  // 是否使用
  bool usingCookie = false;

  String? cookie;
  String? accessToken;

  String retCookie() {
    if (usingCookie) {
      if (cookieInput) {
        return '-c SESSDATA=$cookie';
      } else if (tokenInput) {
        return '-token $accessToken';
      }
    }
    return "";
  }

  // 交互选项部分
  bool onlyParse = false;
  bool notAllStream = false;
  bool outputDebugLog = false;

  String retParseParam() {
    if (onlyParse) {
      return '-info';
    }
    return "";
  }

  String retIsAllStreamParam() {
    if (notAllStream) {
      return '-hs';
    }
    return "";
  }

  String retDebugLogParam() {
    if (outputDebugLog) {
      return '--debug';
    }
    return "";
  }

  // 跳过选项部分
  bool skipZimu = false;
  bool skipCover = false;
  bool skipMixedStream = false;

  String retSkipParam() {
    String ret = "";
    if (skipZimu) {
      ret += "--skip-subtitle ";
    }
    if (skipCover) {
      ret += "--skip-cover ";
    }
    if (skipMixedStream) {
      ret += "--skip-mux ";
    }
    return ret;
  }

  // 分P设置部分
  // 判断是否开启功能
  bool specificP = false;
  bool showAllPname = false;
  bool needPInterval = false;

  String? interval;
  String? pRange;
  // 判断是否输入
  bool intervalInput = false;
  bool pRangeInput = false;

  String retPRange() {
    if (specificP) {
      if (pRangeInput) {
        return "-p $pRange";
      }
    }
    return "";
  }

  String retInterval() {
    if (needPInterval) {
      if (intervalInput) {
        return "--delay-per-page $interval";
      }
    }
    return "";
  }
  String retAllPName() {
    if (showAllPname) {
      return "--show-all";
    }
    return "";
  }

  // 各种目录设置
  String downloadPath = "./download";
  String bbdownPath = "./bbdown/BBDown.exe";
  String ffmpegPath = "./bbdown/ffmpeg.exe";
  String aria2cPath = "./aria2c/aria2c.exe";
  String mp4boxPath = "null";

  bool useAria2c = false;
  bool useMp4box = false;

  String retBBDownPath() {
    return bbdownPath;
  }

  String retDownloadPath() {
    return "--work-dir $downloadPath";
  }

  String retFFMPEGPath() {
    if (ffmpegPath != "./bbdown/ffmpeg.exe" && useMp4box == false) {
      return "--ffmpeg-path $ffmpegPath";
    }
    return "";
  }

  String retARIA2CPath() {
    if (aria2cPath != "null" && useAria2c == true) {
      return "--aria2c-path $aria2cPath --use-aria2c";
    }
    return "";
  }

  String retMP4BOXPath() {
    if (mp4boxPath != "null" && useMp4box == true) {
      return "--mp4box-path $mp4boxPath --use-mp4box";
    }
    return "";
  }

  Future<void> pickDirectory() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    // 用来选择下载目录
    if (directoryPath != null) {
      downloadPath = directoryPath;
      notifyListeners();
      saveDownloadPath();
    }
  }

  Future<void> pickFile(int choice) async {
    // 用来选择可执行文件
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['exe']
    );
    if (file != null) {
      String? path = file.files.single.path;
      if (path != null) {
        switch (choice) {
          case 0:
            // bbdown
            bbdownPath = path;
            saveBBDownPath();
            break;
          case 1:
            // ffmpeg
            ffmpegPath = path;
            saveFFMPEGPath();
            break;
          case 2: 
            // aria2c
            aria2cPath = path;
            saveARIA2CPath();
            break;
          case 3:
            // mp4box
            mp4boxPath = path;
            saveMP4BOXPath();
            break;
        }
        notifyListeners();
      }
      
    }
  }

  Future<void> saveAMChoice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useAria2c', useAria2c);
    prefs.setBool('useMp4box', useMp4box);
  }

  Future<void> loadAMChoice() async {
    final prefs = await SharedPreferences.getInstance();
    useAria2c = prefs.getBool('useAria2c') ?? false;
    useMp4box = prefs.getBool('useMp4box') ?? false;
  }

  Future<void> saveDownloadPath() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('downloadPath', downloadPath);
  }

  Future<void> saveBBDownPath() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('bbdownPath', bbdownPath);
  }

  Future<void> saveARIA2CPath() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('aria2cPath', aria2cPath);
  }
  
  Future<void> saveFFMPEGPath() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ffmpegPath', ffmpegPath);
  }

  Future<void> saveMP4BOXPath() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mp4boxPath', mp4boxPath);
  }

  Future<void> loadPath() async {
    final prefs = await SharedPreferences.getInstance();
    downloadPath = prefs.getString('downloadPath') ?? "./download";
    bbdownPath = prefs.getString('bbdownPath') ?? "./bbdown/BBDown.exe";
    ffmpegPath = prefs.getString('ffmpegPath') ?? "./bbdown/ffmpeg.exe";
    aria2cPath = prefs.getString('aria2cPath') ?? "./aria2c/aria2c.exe";
    mp4boxPath = prefs.getString('mp4boxPath') ?? "null";
  }

  Color themeColor = Colors.deepOrange;

  Map<String, Color> colors = {
    "deepOrange": Colors.deepOrange, 
    "blue": Colors.blue.shade200, 
    "deepPurple": Colors.deepPurple, 
    "pink": Colors.pink, 
  };

  Color getCurrentColor() {
    return themeColor;
  }

  void changeColor(Color? color) {
    themeColor = color!;
    notifyListeners();
  }

  Future<void> saveColor() async {
    final prefs = await SharedPreferences.getInstance();
    String key = colors.entries
                       .firstWhere((element) => element.value == themeColor)
                       .key;
    prefs.setString('color', key);
  }

  Future<void> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    String key = prefs.getString("color") ?? "deepOrange";
    themeColor = colors[key]!;
  }

  // 背景图片
  bool useBackgroundImage = false;
  bool uploadImage = false;
  String? imgPath = './assets/test.jpg';

  // 更新状态
  void notify() {
    notifyListeners();
  }

  Future<void> pickImg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );

    if (result != null) {
      imgPath= result.files.single.path;
      if (imgPath != null) {
        uploadImage = true;
        saveBgSetting();
        notifyListeners();
      }
    }
  }

  Future<void> saveBgSetting() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useBackgroundImage', useBackgroundImage);
    prefs.setBool('uploadImage', uploadImage);
    prefs.setString('imgPath', imgPath!);
  } 

  Future<void> loadBgSetting() async {
    final prefs = await SharedPreferences.getInstance();
    useBackgroundImage = prefs.getBool('useBackgroundImage') ?? false;
    uploadImage = prefs.getBool('uploadImage') ?? false;
    imgPath = prefs.getString('imgPath') ?? './assets/test.jpg';
  }
}
