import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'recents.dart';

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

  Future<FileHandlerReturn> openFile({String? path}) async{
    try{
      File? filePicked;

      // No parameters passed, show file picker
      if(path==null){
        final result = await FilePicker.pickFile(
          type: .any,
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
        String fileContent = await filePicked.readAsString();

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

        return FileHandlerReturn(
          status: 0,
          message: "File opened",
          data: fileContent
        );
      }
      else{
        // Action cancelled
        return FileHandlerReturn(
          status: -1,
          message: "Cancelled"
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
  }

  Future<FileHandlerReturn> reopenFile() async{
    if(filePath==null){
      return FileHandlerReturn(
        status: 1,
        message: "File path null"
      );
    }

    File file = File(filePath!);
    String fileContent = await file.readAsString();

    return FileHandlerReturn(
      status: 0,
      message: "File reopened",
      data: fileContent
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

      final dateTimeNow = DateTime.now();

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

        final dateTimeNow = DateTime.now();

        recentsHandler.add(
          RecentsData(
            fileName: fileName!,
            fileType: fileName!.split(".").last,
            fileSize: data.length,
            filePath: filePath!,
            fileModified: dateTimeNow,
            fileAccessed: dateTimeNow,
          )
        );

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
