import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/todo_list_screen.dart';
import 'package:todo/utils/app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale? savedLocale = await getSavedLocale();
  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatefulWidget {
  final Locale? savedLocale;

  const MyApp({
    super.key,
    this.savedLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _deviceLocale = PlatformDispatcher.instance.locale;

  @override
  void initState() {
    super.initState();

    _deviceLocale = widget.savedLocale ?? PlatformDispatcher.instance.locale;
  }

  void changeLanguage(Locale locale) async {
    setState(() {
      _deviceLocale = locale;
    });
    await saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _deviceLocale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (deviceLocale != null &&
              deviceLocale.languageCode == locale.languageCode) {
            return deviceLocale;
          }
        }
        return _deviceLocale;
      },
      home: TodoListScreen(
        changeLangCallback: () {
          setState(() {
            if (_deviceLocale.languageCode == "ar") {
              changeLanguage(const Locale('en'));
            } else {
              changeLanguage(const Locale('ar'));
            }
          });
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}

Future<void> saveLocale(Locale locale) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('locale', locale.languageCode);
}

Future<Locale?> getSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('locale');
  if (languageCode != null) {
    return Locale(languageCode);
  }
  return null;
}
