import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peripheral/peripheral.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Peripheral peripheral = Peripheral.instance;
  String _platformVersion = 'Unknown';
  bool _isBroadcasting = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await peripheral.getPlatformVersion() ?? "Unknown";
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _toggleAdvertise() async {
    if (await peripheral.isAdvertising ?? false) {
      peripheral.stopService();
      setState(() {
        _isBroadcasting = false;
      });
    } else {
      peripheral.startService(
          "pqEk1YJskZSS8kXBs0VVNO5keVT2", "Miliman13", "Max Nitsche");
      setState(() {
        _isBroadcasting = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Is advertising: $_isBroadcasting'),
              TextButton(
                  onPressed: () => _toggleAdvertise(),
                  child: const Text(
                    'Toggle advertising',
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
