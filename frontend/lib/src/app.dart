import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/l10n/app_localizations.dart';
import '/screens/home_screen.dart';  // Add this import
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case SettingsView.routeName:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => SettingsView(controller: settingsController),
                );
              case '/':
              default:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => const HomeScreen(), // Use our new HomeScreen
                );
            }
          },
        );
      },
    );
  }
}