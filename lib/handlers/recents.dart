// Settings Handler
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

import '../handlers/logger.dart';

List<String> sqlCommands = [
  "create table if not exists recents(name text, type text, size integer, path text primary key, modified text, accessed text);"
];

// Settings file name
const String recentsDatabaseName = "recents.db";

// Default values
const int recentsDefaultVersion = 1;

class RecentsData{
  String fileName;
  String fileType;
  int fileSize;

  String filePath;

  DateTime fileModified;
  DateTime fileAccessed;

  RecentsData({
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.filePath,
    required this.fileModified,
    required this.fileAccessed,
  });
}

class Recents{
  Future<String> getDatabasePath() async{
    final directory = await getDatabasesPath();
    return "$directory/$recentsDatabaseName";
  }

  Future<Database?> getDatabase() async{
    try{
      Database databaseDb = await openDatabase(
        await getDatabasePath(),
        version: 1,
        onCreate: (Database db, int version) async
        {
          for(var command in sqlCommands)
          {
            await db.execute(command);
          }
        },
        onOpen: (Database db) async
        {
          for(var command in sqlCommands)
          {
            await db.execute(command);
          }
        },
      );
      return databaseDb;
    }
    catch(e){
      log("Recents", "Error loading database: $e");
      return null;
    }
  }

  Future<int> add(RecentsData data) async{
    try{
      final databaseDb = await getDatabase();

      if(databaseDb==null){
        return 1;
      }

      await databaseDb.insert(
        "recents",
        {
          'name': data.fileName,
          'type': data.fileType,
          'size': data.fileSize,
          'path': data.filePath,
          'modified': data.fileModified.toIso8601String(),
          'accessed': data.fileAccessed.toIso8601String()
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      log("Recents", "Added");

      return 0;
    }
    catch(e){
      log("Recents", "Error adding: $e");
      return 1;
    }
  }

  Future<List<RecentsData>> load() async{
    //await deleteAll();

    try{
      final databaseDb = await getDatabase();
      if(databaseDb==null){
        return [];
      }

      final List<Map<String, dynamic>> dataMap = await databaseDb.query(
        'recents',
        columns: ['name', 'type', 'size', 'path', 'modified', 'accessed']
      );

      List<RecentsData> recentsList = [];
      for(var data in dataMap)
      {
        recentsList.add(
          RecentsData(
            fileName: data["name"] as String,
            fileType: data["type"] as String,
            fileSize: data["size"] as int,
            filePath: data["path"] as String,
            fileModified: DateTime.parse(data["modified"]),
            fileAccessed: DateTime.parse(data["accessed"]),
          )
        );
      }

      log("Recents", "Loaded ${recentsList.length} recents");
      return recentsList;
    }
    catch(e){
      log("Recents", "Error loading: $e");
      return [];
    }
  }

  Future<int> deleteAll() async{
    try{
      await deleteDatabase(await getDatabasesPath());

      return 0;
    }
    catch(e){
      log("Recents", "Error deleting: $e");
      return 1;
    }
  }

  Future<int> deleteOne(String path) async
  {
    try{
      final databaseDb = await getDatabase();

      if(databaseDb==null){
        return 1;
      }

      await databaseDb.delete(
        "recents",
        where: 'path = ?',
        whereArgs: [path],
      );

      return 0;
    }
    catch(e){
      log("Recents", "Error deleting: $e");
      return 1;
    }
  }
}
