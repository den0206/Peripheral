import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'peripheral_platform_interface.dart';

/// An implementation of [PeripheralPlatform] that uses method channels.
class MethodChannelPeripheral extends PeripheralPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('peripheral');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
