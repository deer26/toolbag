import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/theme_changer.dart';
import 'package:todo/screens/tasks_screen.dart';

void main() => runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [
        Locale("tr", "TR"),
        Locale("en", "US"),
      ],
      saveLocale: true,
      path: "resource/langs",
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.dark,
      builder: (context, _brightness) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.amber,
            brightness: _brightness,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          home: TasksScreen(),
        );
      },
    );
  }
}
