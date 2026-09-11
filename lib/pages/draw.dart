import 'package:material_ui/material_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:window_manager/window_manager.dart';

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'start.dart';

import '../dialogs/snackbar.dart';
import '../handlers/imagehandler.dart';

class DrawPage extends StatefulWidget
{
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}


class DrawingVector extends CustomPainter {
  final List<Offset?> points;
  final double scale;
  final Offset offset;

  final Color drawColor;

  final ui.Image? image;

  DrawingVector({
    required this.drawColor,

    required this.points,
    required this.scale,
    required this.offset,

    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size){
    canvas.save();

    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);

    // Draw image
    if(image!=null){
      canvas.drawImage(image!, Offset.zero, Paint());
    }

    // Draw strokes
    Paint paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0 / scale
    ..strokeCap = .round
    ..strokeJoin = .round
    ..style = .stroke;

    for(int i=0; i<points.length-1; i++){
      Offset? current = points[i];
      Offset? next = points[i+1];
      if(current!=null && next!=null){
        canvas.drawLine(current, next, paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DrawingVector oldDelegate){
    if(oldDelegate.points.length == points.length ||
      oldDelegate.scale != scale ||
      oldDelegate.offset != offset
    ){
      return true;
    }
    return false;
  }
}

class ToolbarButtonData{
  String name;
  IconData icon;
  VoidCallback function;

  ToolbarButtonData({
    required this.name,
    required this.icon,
    required this.function,
  });
}

class _DrawPageState extends State<DrawPage> {
  // Main handlers
  WindowManager windowManager = WindowManager.instance;
  ImageHandler imageHandler = ImageHandler();
  DialogSnackbar dialogSnackbar = DialogSnackbar();

  // Misc variables
  static double mouseSensitivity = 0.0015;

  // Canvas variables
  Size canvasSize = Size.zero;

  double canvasScale = 1.0;
  double canvasScalePrevious = 1.0;

  Offset canvasOffset = Offset.zero;
  Offset canvasOffsetTemp = Offset.zero;
  Offset canvasLastFocalPoint = Offset.zero;

  List<Offset?> canvasPoints = [];
  Offset? canvasPointTemp;

  ui.Image? canvasImage;

  // UI states
  String canvasMode = "none";

  Color canvasDrawColor = Colors.white;
  Color canvasBackgroudColor = Colors.black;

  bool uiToolbarShown = true;

  // Functions
  Offset screenToCanvasCoordinate(Offset screenPosition){
    return (screenPosition-canvasOffset)/canvasScale;
  }

  void mouseZoomHandler(PointerEvent event){
    if(event is PointerScrollEvent){
      final double zoomFactor = math.exp(-event.scrollDelta.dy * mouseSensitivity);
      final double newScale = (canvasScale * zoomFactor).clamp(0.1, 5.0);

      if(newScale==canvasScale){
        return;
      }

      final double actualFactor = newScale / canvasScale;
      final Offset focalPoint = event.localPosition;

      setState(() {
        canvasOffset = focalPoint - (focalPoint - canvasOffset) * actualFactor;
        canvasScale = newScale;
      });
    }
  }

  Future<ui.Image?> flattenVectorToRaster() async{
    final List<Offset?> points = canvasPoints;

    if(points.isEmpty){
      return null;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw previous image
    if(canvasImage!=null){
      canvas.drawImage(canvasImage!, Offset.zero, Paint());
    }

    // Draw strokes
    Paint paint = Paint()
    ..color = canvasDrawColor
    ..strokeWidth = 2.0
    ..strokeCap = .round
    ..strokeJoin = .round
    ..style = .stroke;

    for(int i=0; i<points.length-1; i++){
      Offset? current = points[i];
      Offset? next = points[i+1];
      if(current!=null && next!=null){
        canvas.drawLine(current, next, paint);
      }
    }

    // Convert to picture
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt()
    );

    return image;
  }

  void rasterizeCanvasAndRemovePoints() async{
    final canvasImageNew = await flattenVectorToRaster();
    if(canvasImageNew!=null){
      canvasImage = canvasImageNew;
      canvasPoints.clear();
    }
  }

  // Widget constructors

  // Menu functions
  // File
  void fileNew(){
    viewClear();
    imageHandler.newFile();
  }

  void fileOpen({String? path}) async{
    final result = await imageHandler.openFile(path: path);
    if(mounted){
      dialogSnackbar.showSnackBar(context, result.message, result.status);
    }

    if(result.status==0){
      canvasImage = result.image;
    }
  }

  void fileSave() async{
    final rasterImage = await flattenVectorToRaster();
    if(rasterImage!=null){
      final result = await imageHandler.saveFile(rasterImage);

      if(mounted){
        dialogSnackbar.showSnackBar(context, result.message, result.status);
      }
    }
  }

  void fileSaveAs() async{
    final rasterImage = await flattenVectorToRaster();
    if(rasterImage!=null){
      final result = await imageHandler.saveFileAs(rasterImage);

      if(mounted){
        dialogSnackbar.showSnackBar(context, result.message, result.status);
      }
    }
  }

  void fileQuit(){
    SystemNavigator.pop();
  }

  // View
  void viewRasterize(){
    rasterizeCanvasAndRemovePoints();
  }

  void viewClear(){
    canvasImage = null;
    setState(() {
      canvasPoints = [];
    });
  }

  @override initState(){
    super.initState();
    // Passed path handling
    WidgetsBinding.instance.addPostFrameCallback((_){
      final args = ModalRoute.of(context)!.settings.arguments;
      if(args!=null && args is Map){
        if(args.containsKey("path")){
          fileOpen(path: args["path"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Column(
        crossAxisAlignment: .start,
        children:[
          GestureDetector(
            onPanStart: (details) async{
              await windowManager.startDragging();
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MenuBar(
                style: MenuStyle(
                  alignment: .center,
                  backgroundColor: .all(Colors.transparent),
                  elevation: .all(0),
                  shadowColor: null,
                ),
                children: [
                  SubmenuButton(
                    menuChildren: [
                      MenuItemButton(
                        child: Text("New"),
                        onPressed: (){
                          fileNew();
                        },
                      ),
                      MenuItemButton(
                        child: Text("Open"),
                        onPressed: (){
                          fileOpen();
                        },
                      ),
                      Divider(),
                      MenuItemButton(
                        child: Text("Save"),
                        onPressed: (){
                          fileSave();
                        },
                      ),
                      MenuItemButton(
                        child: Text("Save As"),
                        onPressed: (){
                          fileSaveAs();
                        },
                      ),
                      Divider(),
                      MenuItemButton(
                        child: Text("Quit to Menu"),
                        onPressed: (){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => StartPage()
                            )
                          );
                        },
                      ),
                      MenuItemButton(
                        child: Text("Quit"),
                        onPressed: (){
                          fileQuit();
                        },
                      ),
                    ],
                    child: MenuAcceleratorLabel("&File"),
                  ),

                  /*
                  SubmenuButton(
                    menuChildren: [
                      MenuItemButton(
                        child: Text("Undo"),
                        onPressed: (){

                        },
                      ),
                      Divider(),
                      MenuItemButton(
                        child: Text("Redo"),
                        onPressed: (){

                        },
                      ),
                    ],
                    child: MenuAcceleratorLabel("&Edit"),
                  ),*/

                  SubmenuButton(
                    menuChildren: [
                      MenuItemButton(
                        child: Text("Rasterize"),
                        onPressed: (){
                          viewRasterize();
                        },
                      ),
                    ],
                    child: MenuAcceleratorLabel("&View"),
                  ),
                ],
              )
            ),
          ),
          Divider(height: 0),
          Expanded(
            child: Stack(
              children: [
                // Layer 0
                Listener(
                  behavior: .opaque,
                  onPointerSignal: mouseZoomHandler,
                  child: GestureDetector(
                    behavior: .opaque,
                    child: Container(
                      color: canvasBackgroudColor,
                      child: LayoutBuilder(
                        builder: (context, constraints){
                          canvasSize = Size(constraints.maxWidth, constraints.maxHeight);

                          return CustomPaint(
                            painter: DrawingVector(
                              drawColor: canvasDrawColor,
                              points: canvasPoints,
                              scale: canvasScale,
                              offset: canvasOffset,
                              image: canvasImage
                            ),
                            size: Size.infinite,
                          );
                        },
                      )
                    ),
                    // Scaling
                    onScaleStart:(details) {
                      if(canvasMode=="scribble"){
                        canvasPoints.add(screenToCanvasCoordinate(details.localFocalPoint));
                      }
                      else if(canvasMode=="line"){
                        canvasPoints.add(screenToCanvasCoordinate(details.localFocalPoint));
                      }
                      else if(canvasMode=="pan"){
                        canvasLastFocalPoint = details.localFocalPoint;
                        canvasOffsetTemp = canvasOffset;
                      }
                      else if(canvasMode=="zoom"){
                        canvasScalePrevious = canvasScale;
                      }
                    },
                    onScaleUpdate: (details){
                      setState(() {
                        if(canvasMode=="scribble"){
                          canvasPoints.add(screenToCanvasCoordinate(details.localFocalPoint));
                        }
                        if(canvasMode=="line"){
                          canvasPointTemp = screenToCanvasCoordinate(details.localFocalPoint);
                        }
                        else if(canvasMode=="pan"){
                          Offset delta = details.localFocalPoint - canvasLastFocalPoint;
                          canvasOffset = canvasOffsetTemp + delta;
                        }
                        else if(canvasMode=="zoom"){
                          final double newScale = (canvasScalePrevious*details.scale).clamp(0.1, 5.0);
                          final double actualFactor = newScale/canvasScale;
                          final Offset focalPoint = details.localFocalPoint;
                          canvasOffset = focalPoint - (focalPoint-canvasOffset)*actualFactor;
                          canvasScale = newScale;
                        }
                      });
                    },
                    onScaleEnd: (details){
                      setState(() {
                        if(canvasMode=="scribble"){
                          // line logical end
                          canvasPoints.add(null);
                        }
                        else if(canvasMode=="line"){
                          // line end point
                          if(canvasPointTemp!=null){
                            canvasPoints.add(canvasPointTemp);
                          }
                          canvasPoints.add(null);
                        }
                        else if(canvasMode=="pan"){
                          canvasOffsetTemp = canvasOffset;
                        }
                      });
                    },
                    onSecondaryTap: (){

                    },
                  ),
                ),
                // Show toolbar button
                Visibility(
                  visible: !uiToolbarShown,
                  child: Align(
                    alignment: .centerEnd,
                    child: IconButton.outlined(
                      style: IconButton.styleFrom(
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )
                        )
                      ),
                      icon: Icon(LucideIcons.chevron_left),
                      iconSize: 16,
                      tooltip: "Show toolbar",
                      onPressed: (){
                        setState(() {
                          uiToolbarShown = true;
                        });
                      },
                    ),
                  ),
                ),
                // Toolbar
                Visibility(
                  visible: uiToolbarShown,
                  child: Align(
                    alignment: .centerEnd,
                    //fit: .cover,
                    //color: Colors.black,
                    child: Card(
                      clipBehavior: .hardEdge,
                      child: Padding(
                        padding: .all(8),
                        child: Column(
                          mainAxisAlignment: .center,
                          mainAxisSize: .min,
                          spacing: 8,
                          children: [
                            /*
                              Visibility(
                              visible: true,
                              child: InkWell(
                                onTap: () async{
                                  final Color? colorPicked = await showColorPickerDialog(
                                    context,
                                    canvasDrawColor,
                                    title: Text("Choose foreground color"),
                                  );
                                  setState(() {
                                    if(colorPicked!=null){
                                      canvasDrawColor = colorPicked;
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),

                            Visibility(
                              visible: true,
                              child: SizedBox(
                                height: 8,
                                width: 16,
                                child: Divider(),
                              ),
                            ),*/

                            IconButton.outlined(
                              icon: Icon(LucideIcons.pencil),
                              isSelected: canvasMode=="scribble",
                              tooltip: "Scribble",
                              onPressed: (){
                                setState(() {
                                  canvasMode = "scribble";
                                });
                              },
                            ),
                            IconButton.outlined(
                              icon: Icon(LucideIcons.pencil_line),
                              tooltip: "Line",
                              isSelected: canvasMode=="line",
                              onPressed: (){
                                setState(() {
                                  canvasMode = "line";
                                });
                              },
                            ),
                            IconButton.outlined(
                              icon: Icon(LucideIcons.broom),
                              tooltip: "Clear",
                              onPressed: (){
                                viewClear();
                              },
                            ),

                            SizedBox(
                              height: 8,
                              width: 16,
                              child: Divider(),
                            ),

                            IconButton.outlined(
                              icon: Icon(LucideIcons.hand),
                              tooltip: "Pan",
                              isSelected: canvasMode=="pan",
                              onPressed: (){
                                setState(() {
                                  canvasMode = "pan";
                                });
                              },
                            ),
                            IconButton.outlined(
                              icon: Icon(LucideIcons.zoom_in),
                              tooltip: "Zoom",
                              isSelected: canvasMode=="Zoom",
                              onPressed: (){
                                setState(() {
                                  canvasMode = "zoom";
                                });
                              },
                            ),

                            SizedBox(
                              height: 8,
                              width: 16,
                              child: Divider(),
                            ),

                            IconButton.outlined(
                              icon: Icon(LucideIcons.chevron_right),
                              tooltip: "Hide toolbar",
                              onPressed: (){
                                setState(() {
                                  uiToolbarShown = false;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

