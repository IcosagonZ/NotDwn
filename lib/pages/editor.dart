import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dialogs/snackbar.dart';
import '../handlers/filehandler.dart';

class EditorPage extends StatefulWidget
{
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {

  FileHandler fileHandler = FileHandler();
  DialogSnackbar dialogSnackbar = DialogSnackbar();

  // Controllers
  MenuController menuController = MenuController();
  TextEditingController editorController = TextEditingController();
  FocusNode editorFocusNode = FocusNode();

  // View settings
  double viewFontSize = 16;
  double viewFontStep = 1; // for increment/decrement

  @override initState(){
    super.initState();
  }

  @override
  void dispose() {
    editorController.dispose();
    super.dispose();
  }

  // UI and file handler interactions
  void fileHandlerNew(){
    editorController.text = "";
    fileHandler.newFile();
  }
  void fileHandlerOpen() async{
    final result = await fileHandler.openFile();

    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }

    if(result.status==0){
      editorController.text = result.data!;
    }
  }
  void fileHandlerSave() async{
    final result = await fileHandler.saveFile(editorController.text);

    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }
  }
  void fileHandlerSaveAs() async{
    final result = await fileHandler.saveFileAs(editorController.text);

    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }
  }

  // Misc actions
  void quitProgram(){
    SystemNavigator.pop();
  }

  // View actions
  void fontSizeIncrease(){
    setState(() {
      viewFontSize += viewFontStep;
    });
  }

  void fontSizeDecrease(){
    setState(() {
      viewFontSize -= viewFontStep;
    });
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      body: Column(
        children: [
          // Top bar
          Focus(
            canRequestFocus: false,
            descendantsAreFocusable: false,
            child: Row(
              mainAxisSize: .min,
              children: [
                Expanded(
                  child: MenuBar(
                    children: [
                      // File menu
                      SubmenuButton(
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: Icon(Icons.create),
                            child: Text("New"),
                            onPressed: (){
                              menuController.close();
                              fileHandlerNew();
                            },
                          ),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.file_open),
                            child: Text("Open"),
                            onPressed: (){
                              menuController.close();
                              fileHandlerOpen();
                            },
                          ),
                          Divider(),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.save),
                            child: Text("Save"),
                            onPressed: (){
                              menuController.close();
                              fileHandlerSave();
                            },
                          ),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.save_as),
                            child: Text("Save As..."),
                            onPressed: (){
                              menuController.close();
                              fileHandlerSaveAs();
                            },
                          ),
                          Divider(),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.exit_to_app),
                            child: Text("Quit"),
                            onPressed: (){
                              menuController.close();
                              quitProgram();
                            },
                          ),
                        ],
                        child: MenuAcceleratorLabel("&File"),
                      ),
                      // Edit menu
                      SubmenuButton(
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: Icon(Icons.cut),
                            child: Text("Cut"),
                            onPressed: (){
                              menuController.close();
                              editorFocusNode.requestFocus();
                              if(editorFocusNode.context!=null){
                                Actions.invoke(
                                  editorFocusNode.context!,
                                  CopySelectionTextIntent.cut(
                                    SelectionChangedCause.toolbar
                                  )
                                );
                              }
                            },
                          ),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.copy),
                            child: Text("Copy"),
                            onPressed: (){
                              menuController.close();
                              editorFocusNode.requestFocus();
                              if(editorFocusNode.context!=null){
                                Actions.invoke(
                                  editorFocusNode.context!,
                                  CopySelectionTextIntent.copy
                                );
                              }
                            },
                          ),
                          Divider(),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.paste),
                            child: Text("Paste"),
                            onPressed: (){
                              menuController.close();
                              editorFocusNode.requestFocus();
                              if(editorFocusNode.context!=null){
                                Actions.invoke(
                                  editorFocusNode.context!,
                                  PasteTextIntent(SelectionChangedCause.toolbar)
                                );
                              }
                            },
                          ),
                          /*
                          Divider(),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.find_in_page),
                            child: Text("Find"),
                            onPressed: (){
                              menuController.close();
                            },
                          ),
                          */
                        ],
                        child: MenuAcceleratorLabel("&Edit"),
                      ),
                      // View menu
                      SubmenuButton(
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: Icon(Icons.zoom_in),
                            child: Text("Increase font size"),
                            onPressed: (){
                              //menuController.close();
                              fontSizeIncrease();
                            },
                          ),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.zoom_out),
                            child: Text("Decrease font size"),
                            onPressed: (){
                              //menuController.close();
                              fontSizeDecrease();
                            },
                          ),
                          Divider(),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.fullscreen),
                            child: Text("Fullscreen"),
                            onPressed: (){
                              menuController.close();
                            },
                          ),
                        ],
                        child: MenuAcceleratorLabel("&View"),
                      ),
                      // Help menu
                      SubmenuButton(
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: Icon(Icons.help),
                            child: Text("View documentation"),
                            onPressed: (){
                              menuController.close();
                            },
                          ),
                          Divider(),
                          MenuItemButton(
                            leadingIcon: Icon(Icons.info),
                            child: Text("About NotDwn"),
                            onPressed: (){
                              menuController.close();
                            },
                          ),
                        ],
                        child: MenuAcceleratorLabel("&Help"),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
          // Text field
          Expanded(
            child: Padding(
              padding:EdgeInsetsGeometry.all(16),
              child: TextField(
                controller: editorController,
                focusNode: editorFocusNode,

                maxLines: null,
                enableInteractiveSelection: true,
                keyboardType: .multiline,
                autofocus: true,
                decoration: null,

                selectionWidthStyle: .tight,
                selectionControls: desktopTextSelectionControls,

                style: TextStyle(
                  fontSize: viewFontSize,
                  height: 1.5,
                  //color: Colors.white
                ),
                //cursorColor: colorPrimary,
              )
            )
          ),
          // Status bar
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text("...")
                ),
                Divider(),
                Text("...")
              ],
            )
          )
        ],
      )
    );
  }
}
