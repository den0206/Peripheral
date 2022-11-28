import 'package:flutter_test/flutter_test.dart';
import 'package:peripheral/peripheral.dart';
import 'package:peripheral/peripheral_platform_interface.dart';
import 'package:peripheral/peripheral_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPeripheralPlatform
    with MockPlatformInterfaceMixin
    implements PeripheralPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PeripheralPlatform initialPlatform = PeripheralPlatform.instance;

  test('$MethodChannelPeripheral is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPeripheral>());
  });

  test('getPlatformVersion', () async {
    Peripheral peripheralPlugin = Peripheral();
    MockPeripheralPlatform fakePlatform = MockPeripheralPlatform();
    PeripheralPlatform.instance = fakePlatform;

    expect(await peripheralPlugin.getPlatformVersion(), '42');
  });
}
