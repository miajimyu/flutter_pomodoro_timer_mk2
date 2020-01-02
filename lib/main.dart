import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'pomodoro_timer_page.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  WidgetsFlutterBinding.ensureInitialized(); // ←これがないと初期化前に実行するな的なエラーが出る
  if (Platform.isMacOS) {
    getWindowInfo().then((PlatformWindow windowInfo) {
      // OSによって配置された場所・サイズを取得し
      setWindowFrame(// 場所はそのままに、widthとheightを変更
          Rect.fromCenter(
        center: windowInfo.frame.center,
        width: 360,
        height: 260,
      ));
    });
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Flutter Pomodoro Timer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: PomodoroTimerPage(),
      ),
    );
  }
}
