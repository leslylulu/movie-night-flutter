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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Flutter',
          style: textTheme.headlineMedium,
        ),
        backgroundColor: colorScheme.secondary,
      ),
      body: Container(
        color: colorScheme.surface,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onSecondary,
                  backgroundColor: colorScheme.secondary,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ShareCodeScreen();
                  }));
                },
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share),
                        const SizedBox(width: 8.0),
                        Text(
                          'Share Code',
                          style: textTheme.headlineSmall,
                        ),
                      ],
                    ))),
            const SizedBox(height: 64.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: colorScheme.onSecondary,
                backgroundColor: colorScheme.secondary,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const EnterCodeScreen();
                }));
              },
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.code),
                      const SizedBox(width: 8.0),
                      Text(
                        'Enter Code',
                        style: textTheme.headlineSmall,
                      ),
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
