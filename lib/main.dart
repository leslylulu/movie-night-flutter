import 'package:flutter/material.dart';
import 'package:movie_night/utils/app_state.dart';
import 'screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            textTheme: Theme.of(context).textTheme.copyWith()),
        home: const WelcomeScreen());
  }
}
