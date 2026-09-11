import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:window_manager/window_manager.dart';
import 'package:file_picker/file_picker.dart';

import 'package:intl/intl.dart';

// Pages
import 'editor.dart';
import 'draw.dart';

import '../handlers/recents.dart';
import '../dialogs/snackbar.dart';

class StartPage extends StatefulWidget
{
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // Handlers
  WindowManager windowManager = WindowManager.instance;
  DialogSnackbar dialogSnackbar = DialogSnackbar();
  Recents recentsHandler = Recents();

  String selectedFileType = "All"; // All, Text, Drawing
  List<RecentsData> recentsListVisible = [];

  Future<String?> dialogFileType(BuildContext context, String title) async{
    String? fileType;
    final result = await showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          clipBehavior: .hardEdge,
          contentPadding: .all(16),
          alignment: .center,
          content: IntrinsicHeight(
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: .min,
                mainAxisAlignment: .center,
                children: [
                  Card.filled(
                    clipBehavior: .hardEdge,
                    child: InkWell(
                      child: Center(
                        child: Padding(
                          padding: .all(8),
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Icon(LucideIcons.file_text, size: 50),
                              SizedBox(height: 16),
                              Text("Text")
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        fileType = "Text";
                        Navigator.pop(context);
                      },
                    )
                  ),
                  Card.filled(
                    clipBehavior: .hardEdge,
                    child: InkWell(
                      child: Center(
                        child: Padding(
                          padding: .all(8),
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Icon(LucideIcons.file_image, size: 50),
                              SizedBox(height: 16),
                              Text("Drawing")
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        fileType = "Drawing";
                        Navigator.pop(context);
                      },
                    )
                  ),
                ],
              ),
            ),
          )
        );
      }
    );

    return fileType;
  }

  void quitProgram(){
    SystemNavigator.pop();
  }

  void loadRecents() async{
    final result = await recentsHandler.load();
    final recentsList =result;

    recentsListVisible.clear();

    if(selectedFileType!="All"){
      for(var file in recentsList){
        if(file.fileType==selectedFileType){
          recentsListVisible.add(file);
        }
      }
    }
    else{
      recentsListVisible = recentsList;
    }

    setState(() {
      recentsListVisible = recentsListVisible;
    });
  }

  @override initState(){
    super.initState();
    loadRecents();
  }

  @override
  Widget build(BuildContext context)
  {
    // Appearance themes
    final colorScheme = Theme.of(context).colorScheme;

    Color colorSurfaceContainerLowest = colorScheme.surfaceContainerLowest;
    Color colorSurfaceContainerLow = colorScheme.surfaceContainerLow;

    //Color colorSecondary = colorScheme.secondary;
    //Color colorOnPrimary = colorScheme.onPrimary;
    //Color colorOnSecondary = colorScheme.onSecondary;
    //Color colorSurface = colorScheme.surfaceContainerHighest;

    final textTheme = Theme.of(context).textTheme;

    //final styleDisplayLarge = textTheme.displayLarge;
    //final styleDisplayMedium = textTheme.displayMedium;
    //final styleDisplaySmall = textTheme.displaySmall;

    //final styleHeadlineLarge = textTheme.headlineLarge;
    //final styleHeadlineMedium = textTheme.headlineMedium;
    //final styleHeadlineSmall = textTheme.headlineSmall;

    final styleTitleLarge = textTheme.titleLarge;
    final styleTitleMedium = textTheme.titleMedium;
    final styleTitleSmall = textTheme.titleSmall;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            //center: .center,
            //radius: 0.5,
            colors: [
              colorSurfaceContainerLow,
              colorSurfaceContainerLowest,
            ]
          )
        ),
        child: Row(
            children: [
              Padding(
                padding: .all(2),
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(LucideIcons.file),
                      tooltip: "All files",
                      isSelected: selectedFileType=="All",
                      onPressed: (){
                        loadRecents();
                        setState(() {
                          selectedFileType = "All";
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.file_text),
                      tooltip: "Text",
                      isSelected: selectedFileType=="txt",
                      onPressed: (){
                        loadRecents();
                        setState(() {
                          selectedFileType = "txt";
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.file_image),
                      tooltip: "Drawing",
                      isSelected: selectedFileType=="png",
                      onPressed: (){
                        loadRecents();
                        setState(() {
                          selectedFileType = "png";
                        });
                      },
                    ),
                    Divider(),
                    IconButton(
                      icon: Icon(LucideIcons.settings),
                      tooltip: "Settings",
                      onPressed: (){
                      },
                    ),
                    Expanded(
                      child: DragToMoveArea(
                        child: Align(
                          alignment: .bottomCenter,
                          child: Padding(
                            padding: .only(bottom: 16),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                "NotDwn",
                              ),
                            ),
                          )
                        )
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    DragToMoveArea(
                      child: Row(
                        mainAxisAlignment: .end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            tooltip: "Quit program",
                            onPressed: (){
                              quitProgram();
                            },
                          )
                        ],
                      )
                    ),
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding:EdgeInsetsGeometry.all(16),
                        child: GridView(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1
                          ),
                          children: [
                            Card.filled(
                              clipBehavior: .hardEdge,
                              child: InkWell(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: .min,
                                    children: [
                                      Icon(LucideIcons.file_input, size: 50),
                                      SizedBox(height: 16),
                                      Text("Open")
                                    ],
                                  ),
                                ),
                                onTap: () async{
                                  if(selectedFileType=="Text"){
                                    final filePicked = await FilePicker.pickFile(
                                      type: .any,
                                    );

                                    if(filePicked!=null){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => EditorPage(),
                                          settings: RouteSettings(
                                            arguments: {"path": filePicked.path}
                                          ),
                                        )
                                      );
                                    }
                                  }
                                  else if(selectedFileType=="Drawing"){
                                    final filePicked = await FilePicker.pickFile(
                                      type: .image,
                                    );

                                    if(filePicked!=null){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => DrawPage(),
                                          settings: RouteSettings(
                                            arguments: {"path": filePicked.path}
                                          ),
                                        )
                                      );
                                    }
                                  }
                                  else{
                                    final filePicked = await FilePicker.pickFile(
                                      type: .any,
                                    );

                                    if(filePicked!=null){
                                      final fileType = filePicked.path!.split(".").last;

                                      if (fileType=="png"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => DrawPage(),
                                            settings: RouteSettings(
                                              arguments: {"path": filePicked.path}
                                            ),
                                          )
                                        );
                                      }
                                      else{
                                      //else if(fileType=="txt"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => EditorPage(),
                                            settings: RouteSettings(
                                              arguments: {"path": filePicked.path}
                                            ),
                                          )
                                        );
                                      }
                                      /*
                                      else{
                                        dialogSnackbar.showSnackBar(
                                          context,
                                          "Invalid file type",
                                          1
                                        );
                                      }*/
                                    }
                                  }
                                },
                              ),
                            ),
                            Card.filled(
                              clipBehavior: .hardEdge,
                              child: InkWell(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: .min,
                                    children: [
                                      Icon(LucideIcons.file_plus_corner, size: 50),
                                      SizedBox(height: 16),
                                      Text("New")
                                    ],
                                  ),
                                ),
                                onTap: () async{
                                  if(selectedFileType=="txt"){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EditorPage()
                                      )
                                    );
                                  }
                                  else if(selectedFileType=="png"){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => DrawPage()
                                      )
                                    );
                                  }
                                  else{
                                    final result = await dialogFileType(context, "Open");
                                    if(result=="Drawing"){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => DrawPage()
                                        )
                                      );
                                    }
                                    else if(result=="Text"){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => EditorPage()
                                        )
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: .all(16),
                        child: recentsListVisible.length==0
                        ? Card(
                          child: Center(
                            child: Text("No recents yet")
                          ),
                        )
                        : ListView.builder(
                          itemCount: recentsListVisible.length,
                          itemBuilder: (BuildContext context, int index){
                            final fileData = recentsListVisible[index];
                            final fileType = fileData.fileType;

                            IconData fileIcon = LucideIcons.file_question_mark;

                            if(fileType == "txt"){
                              fileIcon = LucideIcons.file_text;
                            }
                            else if(fileType == "md"){
                              fileIcon = LucideIcons.file_code;
                            }
                            else if(fileType == "png"){
                              fileIcon = LucideIcons.file_image;
                            }
                            else if(fileType == "csv"){
                              fileIcon = LucideIcons.file_spreadsheet;
                            }

                            return Card(
                              clipBehavior: .hardEdge,
                              child: InkWell(
                                child: ListTile(
                                  leading: Icon(fileIcon),
                                  title: Text(fileData.fileName, overflow: .ellipsis,),
                                  subtitle: Column(
                                    mainAxisAlignment: .start,
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(fileData.filePath, overflow: .ellipsis,),
                                      Text(
                                        "Modified: ${DateFormat("d/M/yy h:mm a").format(fileData.fileModified)}",
                                        overflow: .ellipsis,
                                        style: textTheme.bodyMedium
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close),
                                    tooltip: "Delete from history",
                                    onPressed: (){
                                      recentsHandler.deleteOne(fileData.filePath);
                                      loadRecents();
                                    },
                                  ),
                                ),
                                onTap: () async{
                                  if(fileType=="png"){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => DrawPage(),
                                        settings: RouteSettings(
                                          arguments: {"path": fileData.filePath}
                                        ),
                                      )
                                    );
                                  }
                                  else{
                                  //if(fileType=="txt" || fileType=="md"){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EditorPage(),
                                        settings: RouteSettings(
                                          arguments: {"path": fileData.filePath}
                                        ),
                                      )
                                    );
                                  }
                                  /*
                                  else{
                                    dialogSnackbar.showSnackBar(
                                      context,
                                      "Invalid file type",
                                      1
                                    );
                                  }*/
                                },
                              ),
                            );
                          },
                        ),
                      )
                    )
                  ],
                )
              )
            ],
          ),
      )
    );
  }
}
