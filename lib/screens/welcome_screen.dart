import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:android_id/android_id.dart';
import 'package:provider/provider.dart';
import 'share_code_screen.dart';
import 'enter_code_screen.dart';
import '../utils/app_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    String deviceUUID;

    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceUUID = await androidIdPlugin.getId() ?? "Unknown Android ID";
      } else if (Platform.isIOS) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceUUID = iosInfo.identifierForVendor ?? "Unknown iOS UUID";
      } else {
        deviceUUID = "Unsupported platform";
      }
    } catch (e) {
      deviceUUID = "Error: $e";
    }

    if (mounted) {
      Provider.of<AppState>(context, listen: false).setDeviceId(deviceUUID);
    }
  }

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
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // Example usage of FileHelper
            //     const deviceId = 'your_device_id';
            //     await fileHelper.saveDeviceId('device_info.json', deviceId);
            //     final savedDeviceId =
            //         await fileHelper.getDeviceId('device_info.json');
            //     print(savedDeviceId); // Output: your_device_id
            //   },
            //   child: const Text('Save and Get Device ID'),
            // ),
          ]),
        ),
      ),
    );
  }
}
