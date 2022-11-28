import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'peripheral_method_channel.dart';

abstract class PeripheralPlatform extends PlatformInterface {
  /// Constructs a PeripheralPlatform.
  PeripheralPlatform() : super(token: _token);

  static final Object _token = Object();

  static PeripheralPlatform _instance = MethodChannelPeripheral();

  /// The default instance of [PeripheralPlatform] to use.
  ///
  /// Defaults to [MethodChannelPeripheral].
  static PeripheralPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PeripheralPlatform] when
  /// they register themselves.
  static set instance(PeripheralPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
