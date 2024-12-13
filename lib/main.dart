import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/providers/prompt_provider.dart';
import 'package:chatgpt_clone/providers/theme_provider.dart';
import 'package:chatgpt_clone/screens/authScreen/register_screen.dart';
import 'package:chatgpt_clone/screens/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //-----------------------Provider-----------------------
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PromptProvider()),
      ],
      //-----------------------Builder-----------------------
      child: Builder(
        builder: (context) {
          final themeChanger = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'Ai ChatBot',
            debugShowCheckedModeBanner: false,
            themeMode: themeChanger.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: scaffoldBgColor,
              appBarTheme: AppBarTheme(color: cardColor),
              useMaterial3: true,
            ),
            //-----------------------DarkTheme-----------------------
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              appBarTheme: AppBarTheme(color: cardColor),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
