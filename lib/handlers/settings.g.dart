// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsData _$SettingsDataFromJson(Map<String, dynamic> json) => SettingsData(
  version: (json['version'] as num?)?.toInt() ?? 1,
  fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16,
  isDarkMode: json['isDarkMode'] as bool? ?? true,
);

Map<String, dynamic> _$SettingsDataToJson(SettingsData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'fontSize': instance.fontSize,
      'isDarkMode': instance.isDarkMode,
    };
