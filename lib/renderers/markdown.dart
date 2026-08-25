import 'package:flutter/material.dart';

List<Widget> markdownProcess(BuildContext context, String markdownText){
  final textTheme = Theme.of(context).textTheme;

  //final styleDisplayLarge = textTheme.displayLarge;
  //final styleDisplayMedium = textTheme.displayMedium;
  //final styleDisplaySmall = textTheme.displaySmall;

  final styleHeadlineLarge = textTheme.headlineLarge;
  final styleHeadlineMedium = textTheme.headlineMedium;
  final styleHeadlineSmall = textTheme.headlineSmall;

  final styleTitleLarge = textTheme.titleLarge;
  final styleTitleMedium = textTheme.titleMedium;
  final styleTitleSmall = textTheme.titleSmall;

  final lines = markdownText.split("\n");

  // List for all widgets
  List<Widget> widgetList = [];

  for (String line in lines){

    // Heading checker
    if(line.startsWith("#"))
    {
      final level = RegExp(r'#*').firstMatch(line)?.group(0)?.length ?? 0;
      line = line.replaceAll(RegExp(r'#*'), "");
      switch(level){
        case(1):
          widgetList.add(Text(line, style: styleHeadlineLarge));
          break;
        case(2):
          widgetList.add(Text(line, style: styleHeadlineMedium));
          break;
        case(3):
          widgetList.add(Text(line, style: styleHeadlineSmall));
          break;
        case(4):
          widgetList.add(Text(line, style: styleTitleLarge));
          break;
        case(5):
          widgetList.add(Text(line, style: styleTitleMedium));
          break;
        case(6):
          widgetList.add(Text(line, style: styleTitleSmall));
          break;
        default:
          widgetList.add(Text(line));
          break;
      }
    }
    // Checkbox
    else if(line.startsWith("- ["))
    {
      if(line.startsWith("- [ ]"))
      {
        line = line.replaceAll(RegExp(r'^- \[[ xX]\]', caseSensitive: false), "");
        widgetList.add(Row(
          children: [
            Icon(Icons.radio_button_unchecked, size: 16),
            Text(line)
          ],
        ));
      }
      else{
        line = line.replaceAll(RegExp(r'^- \[[ xX]\]', caseSensitive: false), "");
        widgetList.add(Row(
          children: [
            Icon(Icons.radio_button_checked, size: 16),
            Text(line)
          ],
        ));
      }
    }
    // Bullet
    else if(line.startsWith("-"))
    {
      line = line.replaceAll(RegExp(r'-*'), "");
      widgetList.add(Row(
        children: [
          Icon(Icons.circle, size: 8),
          Text(line)
        ],
      ));
    }
    else{
      widgetList.add(Text(line));
    }
    widgetList.add(SizedBox(height: 16));
  }

  if(widgetList.isNotEmpty){
    return widgetList;
  }
  else{
    return [Center(
      child: Text("Error processing markdown")
    )];
  }
}
