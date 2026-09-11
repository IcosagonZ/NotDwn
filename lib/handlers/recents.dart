// Settings Handler

import 'package:material_ui/material_ui.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

import '../handlers/logger.dart';

part 'recents.g.dart';
// Generate using dart run build_runner build --delete-conflicting-outputs

// Settings file name
const String recentsFileName = "recents.json";

// Default values
const int recentsDefaultVersion = 1;

@JsonSerializable()
class SettingsData{
  SettingsData({
    required this.version,
    required this.fontSize,
    required this.isDarkMode
  });

  @JsonKey(defaultValue: recentsDefaultVersion)
  int version;

  // View properties
  @JsonKey(defaultValue: recentsDefaultFontSize)
  double fontSize;

  // Window properties
  @JsonKey(defaultValue: recentsDefaultIsDarkMode)
  bool isDarkMode;

  factory SettingsData.fromJson(Map<String,dynamic> json) => _$SettingsDataFromJson(json);
  Map<String,dynamic> toJson() => _$SettingsDataToJson(this);

  //Default values
  factory SettingsData.defaults(){
    return SettingsData(
      version: recentsDefaultVersion,
      fontSize: recentsDefaultFontSize,
      isDarkMode: recentsDefaultIsDarkMode,
    );
  }
}

class Recents{
  // Themes
  final ThemeData themeDark = GrayscaleTheme.dark;
  final ThemeData themeLight = GrayscaleTheme.light;

  ThemeMode themeModeCurrent = ThemeMode.dark;
  ThemeMode get themeMode => themeModeCurrent;

  // Settings
  bool recentsIsDarkMode = true;
  double recentsFontSize = 16;

  Settings(){
    load();
  }

  Future<String> getPath() async{
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$recentsFileName";
  }

  Future<int> save(SettingsData data) async{
    try{
      final path = await getPath();
      final file = File(path);

      final jsonString = jsonEncode(data.toJson());
      await file.writeAsString(jsonString);

      log("Settings", "Saved recents");

      return 0;
    }
    catch(e){
      log("Settings", "Error saving recents");
      log("Settings", "$e");
      return 1;
    }
  }

  Future<int> create() async{
    return save(SettingsData.defaults());
  }

  Future<({int result,SettingsData? data})> read() async{
    try{
      final path = await getPath();
      final file = File(path);
      if(await file.exists()){
        final dataString = await file.readAsString();
        final dataJson = jsonDecode(dataString);
        final data = SettingsData.fromJson(dataJson);

        return (
          result: 0,
          data: data
        );
      }
      else{
        // Create new recents as it dont exist
        log("Settings", "Creating recents");
        final result = await create();
        if(result==0){
          log("Settings", "Created recents");
        }
        else{
          log("Settings", "Error creating recents");
        }
        return (
          result: result,
          data: SettingsData.defaults()
        );
      }
    }
    catch(e){
      log("Settings", "Error creating recents");
      log("Settings", "$e");

      return (
        result: 0,
        data: null
      );
    }
  }

  Future<void> load() async{
    var result = await read();
    if(result.result==0){
      recentsIsDarkMode = result.data!.isDarkMode;
      themeModeCurrent = recentsIsDarkMode ? ThemeMode.dark : ThemeMode.light;
      recentsFontSize = result.data!.fontSize;
      log("Recents", "Loaded recents");
    }
    else{
      recentsIsDarkMode = recentsDefaultIsDarkMode;
      themeModeCurrent = recentsIsDarkMode ? ThemeMode.dark : ThemeMode.light;
      recentsFontSize = recentsDefaultFontSize;
      log("Recents", "Error loading recents");
    }
    notifyListeners();
  }

  void modify(SettingsData data){
    save(data);
    load();
  }

  void delete() async{
    try{
      final path = await getPath();
      final file = File(path);
      file.delete();
      log("Settings", "Deleted recents");
    }
    catch(e)
    {
      log("Settings", "Error deleting recents");
      log("Settings", "$e");
    }
  }

  // Changing data
  Future<void> toggleDarkMode() async{
    final result = await read();
    if(result.result==0){
      result.data!.isDarkMode = !result.data!.isDarkMode;
      await save(result.data!);
      await load();
    }
  }

  Future<void> incrementFontSize() async{
    final result = await read();
    if(result.result==0){
      result.data!.fontSize = result.data!.fontSize+recentsFontStep;
      await save(result.data!);
      await load();
    }
  }

  Future<void> decrementFontSize() async{
    final result = await read();
    if(result.result==0){
      result.data!.fontSize = result.data!.fontSize-recentsFontStep;
      await save(result.data!);
      await load();
    }
  }
}
