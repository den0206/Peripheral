//
//  BLE_PeripheralManager.swift
//  peripheral
//
//  Created by 酒井ゆうき on 2022/11/27.
//

import Foundation
import CoreBluetooth


let peripheralName = "GymWithMehhhhhhhh";
let userServiceUUID = "50189210-7EB7-4502-BAFE-8E95DCC9C536";

//Characteristics
let userIdCharacteristicUUID = "11967A3A-B135-449B-8117-739A62332697";
let usernameCharacteristicUUID = "2E46E42B-364A-4A82-B843-6FBAAB1315D8";
let displayNameCharacterisitcUUID = "9C245CA3-2250-43F4-8232-FDDB31025BA3";

class BLEPeripheralManager : NSObject, CBPeripheralManagerDelegate {
    
    var localPeripheralManager: CBPeripheralManager!
    var createdService = [CBService]()
    
    var onAdvertisingStateChanged: ((Bool) -> Void)?
    var shouldStartAdvertise: Bool = false
    
    override init() {
        super.init()
        localPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // start the PeripheralManager
    //
    func startService() {
        
        shouldStartAdvertise = true
        peripheralManagerDidUpdateState(localPeripheralManager)
    }
    
    // Stop advertising.
    //
    func stopService() {
        if(localPeripheralManager != nil) {
            print("stop BLEPeripheral")
            self.localPeripheralManager.removeAllServices()
            self.localPeripheralManager.stopAdvertising()
            onAdvertisingStateChanged!(false)
        } else {
            print("Cannot stop because periperalManager is nil")
        }
    }
    
    // delegate
    //
    // Receive bluetooth state
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        if peripheral.state == .poweredOn && shouldStartAdvertise {
            self.createServices()
            shouldStartAdvertise = false
            
        }
        else {
            print("cannot create services. state = " + getState(peripheral: peripheral))
        }
        onAdvertisingStateChanged!(peripheral.isAdvertising)
    }
    
    func createServices() {
        
        print("createServices")
        let characteristicID = CBUUID(string: "890aa912-c414-440d-88a2-c7f66179589b")
        
        // キャラクタリスティックを作成し、設定する
        let characteristic = CBMutableCharacteristic(type: characteristicID,
                                                     properties: [.write, .notify],
                                                     value: nil,
                                                     permissions: .writeable)
        
        // サービスを作成し、そこにキャラクタリスティックを追加する
        let serviceID = CBUUID(string: "9f37e282-60b6-42b1-a02f-7341da5e2eba")
        let service = CBMutableService(type: serviceID, primary: true)
        service.characteristics = [characteristic]
        
        // このサービスをペリフェラルマネージャに登録する
        localPeripheralManager.add(service)
    }
    
    // delegate
    // service + Charactersitic added to peripheral
    //
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?){
        print("peripheralManager didAdd service")
        
        if error != nil {
            print("Error adding services: \(error?.localizedDescription ?? "Error")")
        }
        else {
            let advertisement: [String : Any] = [CBAdvertisementDataServiceUUIDsKey : [service.uuid]] //CBAdvertisementDataLocalNameKey: peripheralName]
            // start the advertisement
            self.localPeripheralManager.startAdvertising(advertisement)
            
            print("Starting to advertise.")
        }
    }
    
    
    
    // Advertising done
    //
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?){
        if error != nil {
            print("peripheralManagerDidStartAdvertising Error :\n \(error?.localizedDescription ?? "Error")")
        }
        else {
            print( "peripheralManagerDidStartAdvertising OK")
        }
    }
    
    // called when Central manager send read request
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
        // prepare advertisement data
        let data: Data = "Hello You".data(using: String.Encoding.utf16)!
        request.value = data //characteristic.value
        // Respond to the request
        localPeripheralManager.respond( to: request, withResult: .success)
        
        // acknowledge : ok
        peripheral.respond(to: request, withResult: CBATTError.success)
    }
    
    // called when central manager send write request
    //
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print( "peripheralManager didReceiveWrite")
        for r in requests {
            print("request uuid: " + r.characteristic.uuid.uuidString)
        }
        
        if requests.count > 0 {
            let str = NSString(data: requests[0].value!, encoding:String.Encoding.utf16.rawValue)!
            print("value sent by central Manager :\n" + String(describing: str))
        }
        peripheral.respond(to: requests[0], withResult: CBATTError.success)
    }
    
    func isAdvertising() -> Bool {
        if (localPeripheralManager == nil) {
            return false
        }
        return localPeripheralManager.isAdvertising
    }
    
    func respond(to request: CBATTRequest, withResult result: CBATTError.Code) {
        print("response requested")
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheral name changed")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("peripheral service modified")
    }
    
    func getState(peripheral: CBPeripheralManager) -> String {
        
        switch peripheral.state {
        case .poweredOn :
            return "poweredON"
        case .poweredOff :
            return "poweredOFF"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        @unknown default:
            fatalError()
        }
    }
}
