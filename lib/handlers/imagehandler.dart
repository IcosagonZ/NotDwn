import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'recents.dart';

class ImageHandlerReturn{
  int status;
  String message;
  ui.Image? image;

  ImageHandlerReturn({
    required this.status,
    required this.message,
    this.image
  });
}

class ImageHandler{
  // Handlers
  Recents recentsHandler = Recents();

  // File details
  String? fileName;
  String? filePath;

  // File handling
  void newFile(){
    fileName = null;
    filePath = null;
  }

  Future<ImageHandlerReturn> openFile({String? path}) async{
    try{
      File? filePicked;

      // No parameters passed, show file picker
      if(path==null){
        final result = await FilePicker.pickFile(
          type: .image,
        );

        if(result!=null){
          filePath = result.path;
          fileName = result.name;

          filePicked = File(filePath!);
        }
      }
      // Parameters passed
      else{
        filePicked = File(path);
        filePath = path;
        fileName = path.split("/").last;
      }


      if(filePicked!=null){
        final bytes = await filePicked.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();

        recentsHandler.add(
          RecentsData(
            fileName: fileName!,
            fileType: fileName!.split(".").last,
            fileSize: await filePicked.length(),
            filePath: filePath!,
            fileModified: await filePicked.lastModified(),
            fileAccessed: await filePicked.lastAccessed(),
          )
        );

        return ImageHandlerReturn(
          status: 0,
          message: "File opened",
          image: frame.image
        );
      }
      // Action cancelled in file handler
      else{
        return ImageHandlerReturn(
          status: -1,
          message: "Cancelled"
        );
      }
    }
    catch(e)
    {
      return ImageHandlerReturn(
        status: 1,
        message: "$e"
      );
    }
  }

  Future<ImageHandlerReturn> reopenFile() async{
    if(filePath==null){
      return ImageHandlerReturn(
        status: 1,
        message: "File path null"
      );
    }

    File file = File(filePath!);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    return ImageHandlerReturn(
      status: 0,
      message: "File reopened",
      image: frame.image
    );
  }

  Future<ImageHandlerReturn> saveFile(ui.Image image) async{
    // Redirect to save as if not opened
    if(filePath==null){
      return saveFileAs(image);
    }

    try{
      final bytes = await image.toByteData(format: .png);
      if(bytes==null){
        return ImageHandlerReturn(
          status: 1,
          message: "Failed to convert to bytes"
        );
      }

      final uint8List = bytes.buffer.asUint8List();
      final file = File(filePath!);
      await file.writeAsBytes(uint8List);

      DateTime dateTimeNow = DateTime.now();

      recentsHandler.add(
        RecentsData(
          fileName: fileName!,
          fileType: fileName!.split(".").last,
          fileSize: await file.length(),
          filePath: filePath!,
          fileModified: dateTimeNow,
          fileAccessed: dateTimeNow,
        )
      );

      return ImageHandlerReturn(
        status: 0,
        message: "Saved file"
      );
    }
    catch(e)
    {
      return ImageHandlerReturn(
        status: 1,
        message: "$e"
      );
    }
  }

  Future<ImageHandlerReturn> saveFileAs(ui.Image image) async{

    try{
      final bytes = await image.toByteData(format: .png);
      if(bytes==null){
        return ImageHandlerReturn(
          status: 1,
          message: "Failed to convert to bytes"
        );
      }

      final uint8List = bytes.buffer.asUint8List();

      final result = await FilePicker.saveFile(
        fileName: fileName ?? "untitled.png",
        bytes: uint8List,
      );

      if(result!=null){
        filePath = result.path;
        fileName = result.path.split("/").last;

        DateTime dateTimeNow = DateTime.now();

        recentsHandler.add(
          RecentsData(
            fileName: fileName!,
            fileType: fileName!.split(".").last,
            fileSize: uint8List.lengthInBytes,
            filePath: filePath!,
            fileModified: dateTimeNow,
            fileAccessed: dateTimeNow,
          )
        );

        return ImageHandlerReturn(
          status: 0,
          message: "Saved file"
        );
      }
    }
    catch(e)
    {
      return ImageHandlerReturn(
        status: 1,
        message: "$e"
      );
    }

    // Action cancelled in file handler
    return ImageHandlerReturn(
      status: -1,
      message: "Cancelled"
    );
  }

  // FILE STATISTICS
  Future<DateTime?> lastModified() async {
    if(filePath==null){
      return null;
    }
    else{
      try{
        final file = File(filePath!);
        final stat = await file.stat();

        return stat.modified;
      }
      catch(e){
        return null;
      }
    }
  }
}
