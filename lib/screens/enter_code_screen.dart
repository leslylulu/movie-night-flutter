import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import 'movie_selection_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  Future<void> _submitCode() async {
    final code = _codeController.text;
    if (code.length != 4) {
      setState(() {
        _errorMessage = "Code must be 4 characters long";
      });
      return;
    }

    final deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final response = await http.get(
      Uri.parse(
          "https://movie-night-api.onrender.com/join-session?code=$code&deviceId=$deviceId"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final sessionId = data["data"]["sessionId"];
      Provider.of<AppState>(context, listen: false).setSessionId(sessionId);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MovieSelectionScreen();
      }));
    } else {
      final data = jsonDecode(response.body);
      setState(() {
        _errorMessage = data['data']['message'];
      });
      _showErrorDialog(_errorMessage!);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Code',
          style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _codeController,
                style: const TextStyle(fontSize: 24.0),
                decoration: InputDecoration(
                  labelText: "Enter Code from your friend",
                  hintText: "4 digit code",
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                ),
                onPressed: _submitCode,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
