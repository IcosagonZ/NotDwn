import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:material_ui/material_ui.dart';

abstract final class GrayscaleTheme {
  static FlexTones colorTonesDark = FlexTones.dark(
    primaryChroma: 0,
    secondaryChroma: 0,
    tertiaryChroma: 0,
    neutralChroma: 0,
    neutralVariantChroma: 0,

    errorChroma: 84,
  );

  static FlexTones colorTonesLight = FlexTones.light(
    primaryChroma: 0,
    secondaryChroma: 0,
    tertiaryChroma: 0,
    neutralChroma: 0,
    neutralVariantChroma: 0,

    errorChroma: 84,
  );

  static ColorScheme darkColorScheme = SeedColorScheme.fromSeeds(
    brightness: .dark,
    primary: Color(0xFFFFFFFF),
    primaryKey: Color(0xFFFFFFFF),
    tones: colorTonesDark,
    surface: Colors.black
  );

  static ColorScheme lightColorScheme = SeedColorScheme.fromSeeds(
    brightness: .light,
    primary: Color(0xFF000000),
    primaryKey: Color(0xFF000000),
    tones: colorTonesLight
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    )
  );
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    )
  );
}

