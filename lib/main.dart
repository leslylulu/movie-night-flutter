import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_night/utils/app_state.dart';
import 'screens/welcome_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: "Poppins",
            colorScheme: const ColorScheme(
                primary: Colors.purple,
                secondary: Colors.yellow,
                surface: Color.fromARGB(255, 253, 255, 242),
                error: Colors.red,
                onPrimary: Colors.white,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onError: Colors.white,
                brightness: Brightness.light),
            textTheme: const TextTheme(
              displayLarge:
                  TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
              displayMedium:
                  TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              displaySmall:
                  TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              headlineMedium:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              headlineSmall:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              titleLarge:
                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 14.0),
              bodyMedium: TextStyle(fontSize: 12.0),
              bodySmall: TextStyle(fontSize: 10.0),
            )),
        home: const WelcomeScreen());
  }
}
