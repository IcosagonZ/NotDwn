import 'package:flutter/material.dart';

void showAbout(BuildContext context){
  showAboutDialog(
    context: context,
    applicationName: "NotDwn",
    applicationVersion: "1.0.0",
    applicationIcon: Icon(Icons.notes),
    applicationLegalese: "A lightweight text editor by IcosagonZ",
  );
}
