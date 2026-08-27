// Main start point

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';

import 'pages/start.dart';
import 'pages/editor.dart';

import 'handlers/settings.dart';
import 'themes/grayscale.dart';

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

  runApp(ChangeNotifierProvider(
    create: (_) => Settings(),
    child: const NotDwnApp(),
  ));
}

class NotDwnApp extends StatelessWidget
{
  const NotDwnApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);

    return MaterialApp(
      title: 'NotDwn',
      theme: GrayscaleTheme.light,
      darkTheme: GrayscaleTheme.dark,
      themeMode: settings.themeMode,
      home: EditorPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
