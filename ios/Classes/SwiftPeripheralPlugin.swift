import Flutter
import UIKit

public class SwiftPeripheralPlugin: NSObject, FlutterPlugin,FlutterStreamHandler {
    private var peripheral = BLEPeripheralManager()
    private var eventSink: FlutterEventSink?
    
    private static let NAMESPACE : String = "plugins.yuuki.com/peripheral"
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "\(NAMESPACE)/methods", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "\(NAMESPACE)/state", binaryMessenger: registrar.messenger())
        
        let instance = SwiftPeripheralPlugin()
        eventChannel.setStreamHandler(instance)
        instance.registerListener();
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "startService":
            print("Start Service");
            startService(call, result)
        case "stopService":
            print("Stop Service");
            stopService(call, result)
        case "isAdvertising":
            isAdvertising(call, result)
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion);
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    
    private func startService(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let map = call.arguments as? Dictionary<String, Any>
      
        peripheral.startService();
        result(nil)
    }
    
    private func stopService(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        peripheral.stopService();
        result(nil)
    }
    
    private func isAdvertising(_ call: FlutterMethodCall,
                               _ result: @escaping FlutterResult) {
        result(peripheral.isAdvertising())
    }
    
    
    func registerListener() {
        peripheral.onAdvertisingStateChanged = {isAdvertising in
            if (self.eventSink != nil) {
                self.eventSink!(isAdvertising)
            }
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
