import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

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
  // File details
  String? fileName;
  String? filePath;

  // File handling
  void newFile(){
    fileName = null;
    filePath = null;
  }

  Future<ImageHandlerReturn> openFile() async{
    try{
      final result = await FilePicker.pickFile(
        type: .image,
      );

      if(result!=null){
        PlatformFile file = result;

        if(file.path!=null){
          filePath = file.path;
          fileName = file.name;

          File filePicked = File(file.path!);

          final bytes = await filePicked.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();

          return ImageHandlerReturn(
            status: 0,
            message: "File opened",
            image: frame.image
          );
        }
        else{
          return ImageHandlerReturn(
            status: 1,
            message: "Invalid file"
          );
        }
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
