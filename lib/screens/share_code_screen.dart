import 'package:flutter/material.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Code',
          style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Text(
              'Share Code',
              style: TextStyle(fontSize: 24.0),
            ),
          ])),
    );
  }
}
