import 'package:flutter/services.dart';

const NAMESPACE = 'plugins.yuuki.com/peripheral';

class Peripheral {
  final MethodChannel _methodChannel =
      const MethodChannel('$NAMESPACE/methods');
  final EventChannel _eventChannel = const EventChannel('$NAMESPACE/state');

  static final Peripheral _instance = Peripheral();
  static Peripheral get instance => _instance;

  Future<String?> getPlatformVersion() async {
    final String? version =
        await _methodChannel.invokeMethod("getPlatformVersion");
    return version;
  }

  Future<void> startService(
      String userId, String username, String displayName) async {
    assert(userId.isNotEmpty);
    if (!(await isAdvertising ?? false)) {
      Map params = <String, String>{
        "userId": userId,
        "username": username,
        "displayName": displayName
      };
      await _methodChannel.invokeMethod('startService', params);
    }
  }

  Future<void> stopService() async {
    if (await (isAdvertising) ?? false) {
      await _methodChannel.invokeMethod('stopService');
    }
  }

  Future<bool?> get isAdvertising async {
    return await _methodChannel.invokeMethod('isAdvertising');
  }

  Stream<bool> getAdvertisingStateChange() {
    return _eventChannel.receiveBroadcastStream().cast<bool>();
  }
}
