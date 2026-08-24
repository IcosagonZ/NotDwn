import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:window_manager/window_manager.dart';

import '../dialogs/snackbar.dart';
import '../dialogs/about.dart';
import '../dialogs/help.dart';

import '../handlers/filehandler.dart';

class EditorPage extends StatefulWidget
{
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  // Main handlers
  FileHandler fileHandler = FileHandler();
  DialogSnackbar dialogSnackbar = DialogSnackbar();
  DateTime dateTimeCurrent = DateTime.now();

  // Window management
  WindowManager windowManager = WindowManager.instance;

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
    editorFocusNode.dispose();
    super.dispose();
  }

  // UI statistics
  String statFileName = "Nothing opened";
  String statFilePath = "N/A";

  DateTime? statLastModified;
  String statLastModifiedText = "Never";

  void uiRefreshStatistics() async{

    dateTimeCurrent = DateTime.now();
    statLastModified = await fileHandler.lastModified();
    statLastModifiedText = "Never";

    setState(() {
      // Basic details
      statFileName = fileHandler.fileName ?? "Nothing opened";
      statFilePath =fileHandler.filePath ?? "N/A";

      statLastModifiedText = DateFormat("d/M/yy h:mm a").format(statLastModified!);
    });
  }

  // UI and file handler interactions
  void fileHandlerNew(){
    editorController.text = "";
    fileHandler.newFile();

    uiRefreshStatistics();
  }
  void fileHandlerOpen() async{
    final result = await fileHandler.openFile();

    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }

    if(result.status==0){
      editorController.text = result.data!;
    }

    uiRefreshStatistics();
  }
  void fileHandlerSave() async{
    final result = await fileHandler.saveFile(editorController.text);

    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }

    uiRefreshStatistics();
  }
  void fileHandlerSaveAs() async{
    final result = await fileHandler.saveFileAs(editorController.text);

    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }

    uiRefreshStatistics();
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
    // Appearance themes
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color colorPrimary = colorScheme.primary;
    //Color colorSecondary = colorScheme.secondary;
    //Color colorOnPrimary = colorScheme.onPrimary;
    //Color colorOnSecondary = colorScheme.onSecondary;
    //Color colorSurface = colorScheme.surfaceContainerHighest;
    Color colorSurfaceBright = colorScheme.surfaceBright;

    //final styleDisplayLarge = textTheme.displayLarge;
    //final styleDisplayMedium = textTheme.displayMedium;
    //final styleDisplaySmall = textTheme.displaySmall;

    //final styleHeadlineLarge = textTheme.headlineLarge;
    //final styleHeadlineMedium = textTheme.headlineMedium;
    //final styleHeadlineSmall = textTheme.headlineSmall;

    //final styleTitleLarge = textTheme.titleLarge;
    //final styleTitleMedium = textTheme.titleMedium;
    //inal styleTitleSmall = textTheme.titleSmall;

    return Scaffold(
      body: Column(
        children: [
          // Top bar
          GestureDetector(
            onPanStart: (details) async{
              await windowManager.startDragging();
            },
            child: Container(
              //color: colorSurface,
              child: Row(
                mainAxisSize: .max,
                children: [
                  SizedBox(width:8),
                  // App logo
                  Text(
                    "NotDwn",
                    style: TextStyle(
                      color: colorPrimary
                    ),
                  ),
                  SizedBox(width:8),
                  Expanded(
                    child: MenuBar(
                      style: MenuStyle(
                        alignment: .center,
                        backgroundColor: .all(Colors.transparent),
                        elevation: .all(0),
                        shadowColor: null,
                      ),
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
                          ],
                          child: MenuAcceleratorLabel("&View"),
                        ),
                        // Help menu
                        SubmenuButton(
                          menuChildren: [
                            MenuItemButton(
                              leadingIcon: Icon(Icons.help),
                              child: Text("Help"),
                              onPressed: (){
                                menuController.close();
                                showHelpDialog(context);
                              },
                            ),
                            Divider(),
                            MenuItemButton(
                              leadingIcon: Icon(Icons.info),
                              child: Text("About NotDwn"),
                              onPressed: (){
                                menuController.close();
                                showAbout(context);
                              },
                            ),
                          ],
                          child: MenuAcceleratorLabel("&Help"),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    tooltip: "Quit program",
                    color: colorPrimary,
                    onPressed: (){
                      quitProgram();
                    },
                  )
                ],
              ),
            )
          ),
          Divider(
            height: 0,
            color: colorSurfaceBright,
          ),
          // Text field
          Expanded(
            child: Padding(
              padding:EdgeInsetsGeometry.all(16),
              child: CallbackShortcuts(
                bindings: {
                  // New with Ctrl + N
                  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): () => {
                    fileHandlerNew()
                  },

                  // New with Ctrl + O
                  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): () => {
                    fileHandlerOpen()
                  },

                  // Save with Ctrl + S
                  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): () => {
                    fileHandlerSave()
                  },

                  // Quit with Ctrl + Q
                  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ): () => {
                    quitProgram()
                  },

                  // Increase font size with Ctrl + =
                  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.equal): () => {
                    fontSizeIncrease()
                  },

                  // Decrease font size with Ctrl + -
                  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus): () => {
                    fontSizeDecrease()
                  }
                },
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
                ),
              )
            )
          ),
          Divider(
            height: 0,
            color: colorSurfaceBright,
          ),
          // Status bar
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(statFileName)
                ),
                Divider(),
                Text("Modified: $statLastModifiedText")
              ],
            )
          )
        ],
      )
    );
  }
}
