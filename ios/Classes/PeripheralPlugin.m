#import "PeripheralPlugin.h"
#if __has_include(<peripheral/peripheral-Swift.h>)
#import <peripheral/peripheral-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "peripheral-Swift.h"
#endif

@implementation PeripheralPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPeripheralPlugin registerWithRegistrar:registrar];
}
@end
