import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/start.dart';
import 'pages/editor.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();

  WindowManager windowManager = WindowManager.instance;
  windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    titleBarStyle: .hidden
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    }
  );

  runApp(const NotDwnApp());
}

class NotDwnApp extends StatelessWidget
{
  const NotDwnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotDwn',
      theme: ThemeData.dark(),
      home: EditorPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
