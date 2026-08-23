import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class FileHandlerReturn{
  int status;
  String message;
  String? data;

  FileHandlerReturn({
    required this.status,
    required this.message,
    this.data
  });
}

class FileHandler{
  // File details
  String? fileName;
  String? filePath;

  // File handling
  void newFile(){

    fileName = null;
    filePath = null;
  }

  Future<FileHandlerReturn> openFile() async{
    try{
      final result = await FilePicker.pickFile(
        type: .any,
      );

      if(result!=null){
        PlatformFile file = result;

        if(file.path!=null){
          filePath = file.path;
          fileName = file.name;

          File filePicked = File(file.path!);
          String fileContent = await filePicked.readAsString();

          return FileHandlerReturn(
            status: 0,
            message: "File opened",
            data: fileContent
          );
        }
        else{
          return FileHandlerReturn(
            status: 1,
            message: "Invalid file"
          );
        }
      }
    }
    catch(e)
    {
      return FileHandlerReturn(
        status: 1,
        message: "$e"
      );
    }

    // Action cancelled in file handler
    return FileHandlerReturn(
      status: -1,
      message: "Cancelled"
    );
  }

  Future<FileHandlerReturn> saveFile(String data) async{
    if(data.isEmpty){
      return FileHandlerReturn(
        status: 1,
        message: "Nothing to save"
      );
    }

    // Redirect to save as if not opened
    if(filePath==null){
      return saveFileAs(data);
    }

    try{
      File file = File(filePath!);

      await file.writeAsString(data);

      return FileHandlerReturn(
        status: 0,
        message: "Saved file"
      );
    }
    catch(e)
    {
      return FileHandlerReturn(
        status: 1,
        message: "$e"
      );
    }
  }

  Future<FileHandlerReturn> saveFileAs(String data) async{
    if(data.isEmpty){
      return FileHandlerReturn(
        status: 1,
        message: "Nothing to save"
      );
    }

    try{
      final bytes = data.codeUnits;

      final result = await FilePicker.saveFile(
        fileName: fileName ?? "untitled.txt",
        bytes: Uint8List.fromList(bytes),
      );

      if(result!=null){
        filePath = result.path;
        fileName = result.path.split("/").last;

        return FileHandlerReturn(
          status: 0,
          message: "Saved file"
        );
      }
    }
    catch(e)
    {
      return FileHandlerReturn(
        status: 1,
        message: "$e"
      );
    }

    // Action cancelled in file handler
    return FileHandlerReturn(
      status: -1,
      message: "Cancelled"
    );
  }
}
