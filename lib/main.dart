// Main start point

import 'package:material_ui/material_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'pages/start.dart';
import 'pages/editor.dart';
import 'pages/draw.dart';

import 'handlers/settings.dart';
import 'themes/grayscale.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();

  WindowManager windowManager = WindowManager.instance;
  windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    titleBarStyle: .hidden
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    }
  );

  if(Platform.isLinux || Platform.isWindows)
  {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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
      home: StartPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
