// Settings Handler

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

import 'logger.dart';
import '../themes/grayscale.dart';

part 'settings.g.dart';
// Generate using dart run build_runner build --delete-conflicting-outputs

// Settings file name
const String settingsFileName = "settings.json";

// Default values
const int settingsDefaultVersion = 1;
const bool settingsDefaultIsDarkMode = true;

const double settingsDefaultFontSize = 16;
const double settingsFontStep = 1; // for increment/decrement

@JsonSerializable()
class SettingsData{
  SettingsData({
    required this.version,
    required this.fontSize,
    required this.isDarkMode
  });

  @JsonKey(defaultValue: settingsDefaultVersion)
  int version;

  // View properties
  @JsonKey(defaultValue: settingsDefaultFontSize)
  double fontSize;

  // Window properties
  @JsonKey(defaultValue: settingsDefaultIsDarkMode)
  bool isDarkMode;

  factory SettingsData.fromJson(Map<String,dynamic> json) => _$SettingsDataFromJson(json);
  Map<String,dynamic> toJson() => _$SettingsDataToJson(this);

  //Default values
  factory SettingsData.defaults(){
    return SettingsData(
      version: settingsDefaultVersion,
      fontSize: settingsDefaultFontSize,
      isDarkMode: settingsDefaultIsDarkMode,
    );
  }
}

class Settings extends ChangeNotifier{
  // Themes
  final ThemeData themeDark = GrayscaleTheme.dark;
  final ThemeData themeLight = GrayscaleTheme.light;

  ThemeMode themeModeCurrent = ThemeMode.dark;
  ThemeMode get themeMode => themeModeCurrent;

  // Settings
  bool settingsIsDarkMode = true;
  double settingsFontSize = 16;

  Settings(){
    load();
  }

  Future<String> getPath() async{
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$settingsFileName";
  }

  Future<int> save(SettingsData data) async{
    try{
      final path = await getPath();
      final file = File(path);

      final jsonString = jsonEncode(data.toJson());
      await file.writeAsString(jsonString);

      log("Settings", "Saved settings");

      return 0;
    }
    catch(e){
      log("Settings", "Error saving settings");
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
        // Create new settings as it dont exist
        log("Settings", "Creating settings");
        final result = await create();
        if(result==0){
          log("Settings", "Created settings");
        }
        else{
          log("Settings", "Error creating settings");
        }
        return (
          result: result,
          data: SettingsData.defaults()
        );
      }
    }
    catch(e){
      log("Settings", "Error creating settings");
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
      settingsIsDarkMode = result.data!.isDarkMode;
      themeModeCurrent = settingsIsDarkMode ? ThemeMode.dark : ThemeMode.light;
      settingsFontSize = result.data!.fontSize;
      log("Settings", "Loaded settings");
    }
    else{
      settingsIsDarkMode = settingsDefaultIsDarkMode;
      themeModeCurrent = settingsIsDarkMode ? ThemeMode.dark : ThemeMode.light;
      settingsFontSize = settingsDefaultFontSize;
      log("Settings", "Error loading settings");
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
      log("Settings", "Deleted settings");
    }
    catch(e)
    {
      log("Settings", "Error deleting settings");
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
      result.data!.fontSize = result.data!.fontSize+settingsFontStep;
      await save(result.data!);
      await load();
    }
  }

  Future<void> decrementFontSize() async{
    final result = await read();
    if(result.result==0){
      result.data!.fontSize = result.data!.fontSize-settingsFontStep;
      await save(result.data!);
      await load();
    }
  }
}
