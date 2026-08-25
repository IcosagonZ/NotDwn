import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_view/split_view.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:window_manager/window_manager.dart';

import '../dialogs/snackbar.dart';
import '../dialogs/about.dart';
import '../dialogs/help.dart';

import '../handlers/filehandler.dart';

import '../renderers/markdown.dart';

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
  SplitViewController splitViewController = SplitViewController(
    weights: [
      1.0,
      0.0
    ]
  );

  // Window management
  WindowManager windowManager = WindowManager.instance;

  // Controllers
  MenuController menuController = MenuController();
  TextEditingController editorController = TextEditingController();
  FocusNode editorFocusNode = FocusNode();
  Timer? editorTimer;

  // Main variables
  String displayText = "Nothing opened";
  bool fileIsMarkdown = false;

  // View settings
  double viewFontSize = 16;
  double viewFontStep = 1; // for increment/decrement

  bool viewIsFullscreen = false;
  bool viewMarkdown = false;

  @override initState(){
    super.initState();
    initWindow();
  }

  void initWindow() async {
    viewIsFullscreen = await windowManager.isFullScreen();
  }

  @override
  void dispose() {
    editorController.dispose();
    editorFocusNode.dispose();
    uiUpdateTimerDisable();

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
      fileIsMarkdown = statFileName.endsWith(".md");

      statLastModifiedText = DateFormat("d/M/yy h:mm a").format(statLastModified!);
    });
  }

  void uiUpdateDisplayText(){
    setState(() {
      displayText = editorController.text;
    });
  }

  void uiUpdateTimerEnable(){
    editorTimer = Timer.periodic(Duration(seconds: 2), (_) => uiUpdateDisplayText());
  }

  void uiUpdateTimerDisable(){
    editorTimer?.cancel();
    editorTimer = null;
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

  void viewFullscreenToggle() async{
    viewIsFullscreen = await windowManager.isFullScreen();

    windowManager.setFullScreen(!viewIsFullscreen);
    setState(() {
      viewIsFullscreen = !viewIsFullscreen;
    });
  }

  // Widgets
  Widget editorWidget()
  {
    return CallbackShortcuts(
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
        onEditingComplete: (){
          if(viewMarkdown){
            uiUpdateDisplayText();
          }
        },
        //cursorColor: colorPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    // Appearance themes
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;

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
                        // Window menu
                        SubmenuButton(
                          menuChildren: [
                            MenuItemButton(
                              trailingIcon: AbsorbPointer(
                                absorbing: true,
                                child: Checkbox(
                                  tristate: false,
                                  value: viewMarkdown,
                                  onChanged: (value){
                                  },
                                ),
                              ),
                              child: Text("Markdown render"),
                              onPressed: (){
                                if(fileIsMarkdown){
                                  if(viewMarkdown)
                                  {
                                    uiUpdateTimerDisable();
                                    splitViewController.weights = [1, 0];
                                  }
                                  else{
                                    uiUpdateDisplayText();
                                    splitViewController.weights = [0.5, 0.5];
                                    uiUpdateTimerEnable();
                                  }
                                  setState(() {
                                    viewMarkdown = !viewMarkdown;
                                  });
                                }
                                else{
                                  dialogSnackbar.showSnackBar(
                                    context,
                                    "Current file is not markdown",
                                    0
                                  );
                                }
                              },
                            ),
                            Divider(),
                            MenuItemButton(
                              leadingIcon: Icon(Icons.fullscreen),
                              trailingIcon: AbsorbPointer(
                                absorbing: true,
                                child: Checkbox(
                                  tristate: false,
                                  value: viewIsFullscreen,
                                  onChanged: (value){
                                  },
                                ),
                              ),
                              child: Text("Fullscreen"),
                              onPressed: (){
                                viewFullscreenToggle();
                              },
                            ),
                          ],
                          child: MenuAcceleratorLabel("&Window"),
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
              child: viewMarkdown ? SplitView(
                controller: splitViewController,
                viewMode: .Horizontal,
                gripColor: colorSurfaceBright,
                gripColorActive: colorPrimary,
                gripSize: 2.0,
                children: [
                  editorWidget(),
                  Padding(
                    padding: .all(16),
                    child: ListView(
                      children: markdownProcess(context, displayText),
                    ),
                  )
                ],
              ) : editorWidget(),
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
