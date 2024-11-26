import 'package:flutter/material.dart';
import 'screens/share_code_screen.dart';
import 'screens/enter_code_screen.dart';

void main() {
  runApp(const MainApp());
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

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //TODO add platform_device_id: ^1.0.1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Flutter',
          style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        color: const Color.fromARGB(255, 253, 255, 242),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ShareCodeScreen();
                  }));
                },
                child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 8.0),
                        Text(
                          'Share Code',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ))),
            const SizedBox(height: 64.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const EnterCodeScreen();
                }));
              },
              child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.code),
                      SizedBox(width: 8.0),
                      Text(
                        'Enter Code',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
