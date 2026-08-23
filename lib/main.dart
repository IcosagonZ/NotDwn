import 'package:flutter/material.dart';

import 'pages/start.dart';
import 'pages/editor.dart';

void main()
{
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
