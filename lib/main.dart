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
  Locale locale = Locale("en");

  @override
  void initState() {
    super.initState();
    locale = widget.savedLocale ??
        Locale('en'); // Default to English if no saved locale
  }

  void changeLanguage(Locale locale) async {
    setState(() {
      this.locale = locale;
    });
    await saveLocale(locale); // Save the locale when changed
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
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
        return locale;
      },
      home: TodoListScreen(
        changeLangCallback: () {
          setState(() {
            if (locale.languageCode == "ar") {
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

// Save selected locale to SharedPreferences
Future<void> saveLocale(Locale locale) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('locale', locale.languageCode);
}

// Load saved locale from SharedPreferences
Future<Locale?> getSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('locale');
  if (languageCode != null) {
    return Locale(languageCode);
  }
  return null;
}
