import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context){
  showDialog(
    context: context,
    builder:(context) {
      return SimpleDialog(
        title: Text("Help"),
        clipBehavior: .hardEdge,
        contentPadding: .all(16),
        children: [
          Center(
            child: Text("NotDown"),
          ),
          Center(
            child: Text("A lightweight text editor"),
          ),
          Divider(),
          Text("Menubar functions"),
          Text("File menu"),
          Text("New - create a new blank file"),
          Text("Open - open an existing file"),
          Text("Save - save current file, overwriting any data"),
          Text("Save As - save current document as new file, and new file will be currently editing file"),
          Text("Quit - quit program"),
        ],
      );
    },
  );
}
