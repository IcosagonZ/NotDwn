import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [GrayscaleTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: GrayscaleTheme.light,
///   darkTheme: GrayscaleTheme.dark,
/// );
abstract final class GrayscaleTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.greys,
    // Input color modifiers.
    usedColors: 1,
    // Surface color adjustments.
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 1,
    // Convenience direct styling properties.
    appBarStyle: FlexAppBarStyle.background,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      thinBorderWidth: 0.5,
      splashType: FlexSplashType.noSplash,
      defaultRadius: 10.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        segmentedButtonSchemeColor: SchemeColor.primary,
        sliderTrackHeight: 4,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorBackgroundAlpha: 21,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 8.0,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        listTileSelectedSchemeColor: SchemeColor.primary,
        listTileSelectedTileSchemeColor: SchemeColor.onPrimary,
        fabUseShape: true,
        fabAlwaysCircular: true,
        chipBlendColors: false,
        popupMenuRadius: 6.0,
        popupMenuElevation: 4.0,
        alignedDropdown: true,
        tooltipSchemeColor: SchemeColor.surfaceContainer,
        tooltipOpacity: null,
        dialogElevation: 3.0,
        dialogRadius: 20.0,
        snackBarRadius: 16,
        snackBarBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
        snackBarActionSchemeColor: SchemeColor.onSurface,
        appBarCenterTitle: false,
        tabBarIndicatorAnimation: TabIndicatorAnimation.linear,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuRadius: 6.0,
        menuElevation: 4.0,
        menuBarRadius: 0.0,
        menuBarElevation: 1.0,
        searchUseGlobalShape: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarElevation: 0.0,
        navigationRailSelectedLabelSchemeColor: SchemeColor.white,
        navigationRailMutedUnselectedLabel: true,
        navigationRailSelectedIconSchemeColor: SchemeColor.white,
        navigationRailMutedUnselectedIcon: true,
        navigationRailUseIndicator: false,
        navigationRailIndicatorOpacity: 1.00,
    ),
    // ColorScheme seed generation configuration for light mode.
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true,
    ),
    tones: FlexSchemeVariant.oneHue
    .tones(Brightness.light),
    // Direct ThemeData properties.
    visualDensity: VisualDensity.compact,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.greys,
    // Input color modifiers.
    usedColors: 1,
    // Surface color adjustments.
    darkIsTrueBlack: true,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      scaffoldBackgroundSchemeColor: SchemeColor.black,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.noSplash,
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 10.0,
        thinBorderWidth: 0.5,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        segmentedButtonSchemeColor: SchemeColor.primary,
        sliderTrackHeight: 4,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorBackgroundAlpha: 43,
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 8.0,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        listTileSelectedSchemeColor: SchemeColor.primary,
        listTileSelectedTileSchemeColor: SchemeColor.onPrimary,
        fabUseShape: true,
        fabAlwaysCircular: true,
        chipBlendColors: false,
        popupMenuRadius: 6.0,
        popupMenuElevation: 4.0,
        alignedDropdown: true,
        tooltipSchemeColor: SchemeColor.surfaceContainer,
        tooltipOpacity: null,
        dialogElevation: 3.0,
        dialogRadius: 20.0,
        snackBarRadius: 16,
        snackBarBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
        snackBarActionSchemeColor: SchemeColor.onSurface,
        appBarBackgroundSchemeColor: SchemeColor.black,
        appBarCenterTitle: false,
        bottomAppBarSchemeColor: SchemeColor.black,
        tabBarIndicatorAnimation: TabIndicatorAnimation.linear,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuRadius: 6.0,
        menuElevation: 4.0,
        menuBarRadius: 0.0,
        menuBarElevation: 1.0,
        searchUseGlobalShape: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarElevation: 0.0,
        navigationRailSelectedLabelSchemeColor: SchemeColor.white,
        navigationRailMutedUnselectedLabel: true,
        navigationRailSelectedIconSchemeColor: SchemeColor.white,
        navigationRailMutedUnselectedIcon: true,
        navigationRailUseIndicator: false,
        navigationRailIndicatorOpacity: 1.00,
    ),
    // ColorScheme seed configuration setup for dark mode.
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
    ),
    tones: FlexSchemeVariant.oneHue
    .tones(Brightness.dark),
    // Direct ThemeData properties.
    visualDensity: VisualDensity.compact,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
