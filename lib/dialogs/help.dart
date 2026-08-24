import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context){
  // Theming and text styles
  final text_theme = Theme.of(context).textTheme;

  final style_titlelarge = text_theme.titleLarge;
  final style_titlemedium = text_theme.titleMedium;
  final style_titlesmall = text_theme.titleSmall;

  showDialog(
    context: context,
    builder:(context) {
      return AlertDialog(
        title: Text("Help"),
        clipBehavior: .hardEdge,
        contentPadding: .all(16),
        content:
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                Center(
                  child: Text("NotDown", style: style_titlelarge,),
                ),
                Center(
                  child: Text("A lightweight text editor", style: style_titlesmall),
                ),
                Divider(),
                Text("Menubar functions", style: style_titlemedium),
                Divider(),
                Text("File menu", style: style_titlesmall),
                Text("New - create a new blank file"),
                Text("Open - open an existing file"),
                Text("Save - save current file, overwriting any data"),
                Text("Save As - save current document as new file, and new file will be currently editing file"),
                Text("Quit - quit program"),
                Divider(),
                Text("View menu", style: style_titlesmall),
                Text("Increase font size - increase editor font size"),
                Text("Decrease font size - decrease editor font size"),
                Divider(),
                Text("Shortcuts", style: style_titlemedium),
                Divider(),
                Text("Ctrl + S - save"),
                Text("Ctrl + = - increase editor font size"),
                Text("Ctrl + - - decrease editor font size"),
              ],
            ),
          )
        )
      );
    },
  );
}
