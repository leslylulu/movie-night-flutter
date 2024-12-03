import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'enter_code_screen.dart';
import 'movie_selection_screen.dart';

class ShareCodeScreen extends StatefulWidget {
  final String deviceId;
  const ShareCodeScreen({super.key, required this.deviceId});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

/**
 * Share Code Screen Requirements
As loading this screen, make an HTTP call to the MovieNight API /start-session endpoint.
Save the session id in a place that can be accessed from other screens.
Have a button that will navigate to the Movie Selection Screen.
#
 */

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  late String _deviceId;
  String _code = "Fetching...";

  @override
  void initState() {
    super.initState();
    _deviceId = widget.deviceId;
    _startSession();
  }

  Future<void> _startSession() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://movie-night-api.onrender.com/start-session?device_id=$_deviceId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data == $data");
        setState(() {
          _code = data['data']['code'];
        });
        // Save session ID in a place accessible from other screens
        // For example, using a shared preference or a state management solution
      } else {
        setState(() {
          _code = 'Failed to start session';
        });
      }
    } catch (e) {
      setState(() {
        _code = 'Error: $e';
      });
    }
  }

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
      body: Container(
        color: const Color.fromARGB(255, 253, 255, 242),
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _code,
                  style: const TextStyle(
                      fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32.0),
                const Text("Share this code with your friends"),
                const SizedBox(height: 120.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MovieSelectionScreen();
                      }));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Begin",
                        style: TextStyle(fontSize: 18),
                      ),
                    ))
              ]),
        ),
      ),
    );
  }
}
