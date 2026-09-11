import 'package:material_ui/material_ui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:window_manager/window_manager.dart';

// Pages
import 'editor.dart';
import 'draw.dart';

class StartPage extends StatefulWidget
{
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  String selectedFileType = "All"; // All, Text, Drawing

  WindowManager windowManager = WindowManager.instance;

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

  @override
  Widget build(BuildContext context)
  {
    // Appearance themes
    final colorScheme = Theme.of(context).colorScheme;

    Color colorSurfaceContainerLowest = colorScheme.surfaceContainerLowest;
    Color colorSurfaceContainerLow = colorScheme.surfaceContainerLow;

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
                        setState(() {
                          selectedFileType = "All";
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.file_text),
                      tooltip: "Text",
                      isSelected: selectedFileType=="Text",
                      onPressed: (){
                        setState(() {
                          selectedFileType = "Text";
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.file_image),
                      tooltip: "Drawing",
                      isSelected: selectedFileType=="Drawing",
                      onPressed: (){
                        setState(() {
                          selectedFileType = "Drawing";
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
                            onPressed: (){

                            },
                          )
                        ],
                      )
                    ),
                    Expanded(
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
                                      Icon(LucideIcons.file_plus_corner, size: 50),
                                      SizedBox(height: 16),
                                      Text("New")
                                    ],
                                  ),
                                ),
                                onTap: () async{
                                  if(selectedFileType=="Text"){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EditorPage()
                                      )
                                    );
                                  }
                                  else if(selectedFileType=="Drawing"){
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
                            /*
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
                                },
                              ),
                            ),
                            */
                          ],
                        )
                      ),
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
