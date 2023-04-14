//
//  BluetoothView.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-04-04.
//

import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    

    var centralManager: CBCentralManager!
    private var arduinoPeripheral: CBPeripheral!
    private var rxCharacteristic: CBCharacteristic!
    var contact_emergency : Bool = false
    @Published var heart_data : [Double] = []
    @Published var oxygen_data : [Double] = []
    @Published var activity_data : [Double] = []
    @Published var peripheralServices : [String] = []
    var phoneNumbers = PersonalData()
    
    override init(){
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
        
    func startScanning() -> Void {
        print("Scanning...")
        centralManager?.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.centralManager?.stopScan()
        }
    }
    
    
    
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOff:
            print("Device is powered off.")
        case .poweredOn:
            print("Device is powered on.")
            startScanning()
        case .unsupported:
            print("Device is not supported.")
        case .unauthorized:
            print("Device unauthorized.")
        case .unknown:
            print("Unknown device.")
        case .resetting:
            print("Device is resetting.")
        @unknown default:
            print("ERROR")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String :Any], rssi RSSI: NSNumber) {
        arduinoPeripheral = peripheral
        
        
        print("Peripheral discovered: \(peripheral)")
        if peripheral.identifier == NSUUID(uuidString: "A336BFE9-DFC2-53DE-6C91-A5559CDC6028")! as UUID {
            print("Found Arduino!")
            centralManager?.stopScan()
            arduinoPeripheral = peripheral
            arduinoPeripheral.delegate = self
            centralManager?.connect(arduinoPeripheral!, options: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        arduinoPeripheral.discoverServices([])
    }
    
 
    
}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("******************************************************")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let services = peripheral.services else{
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
            self.peripheralServices.append("My SmartBand")
        }
        print("Discovered Services: \(services)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Found \(characteristics.count) characteristics.")
        
        for characteristic in characteristics {
                rxCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                
                print("RX Characteristic: \(rxCharacteristic.uuid)")
            
        }
    }
    func call_emergency_services() {
        if let url = URL(string: "tel://9059238079"), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }

    func text_emergency_contacts(phone_number : String){
        let url = "sms://" + phone_number + "&body=EMERGENCY ALERT:\n\(self.phoneNumbers.first_name) \(self.phoneNumbers.last_name)'s vitals are below an acceptable level and is in need of medical assistance immediately. 911 has been contacted.\n You have been set as an emergency contact."

        let str_url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: str_url)!, options: [:], completionHandler: nil)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var characteristicASCIIValue = NSString()
        
        guard characteristic == rxCharacteristic,
              
                let characteristicValue = characteristic.value,
              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }
        
        characteristicASCIIValue = ASCIIstring
        if self.contact_emergency == true {
            call_emergency_services()
            text_emergency_contacts(phone_number: self.phoneNumbers.ec_one_num)
            text_emergency_contacts(phone_number: self.phoneNumbers.ec_two_num)
        }
        
        
        if self.peripheralServices.last == "10"{
            if characteristicValue[0] != 0 {
                if characteristicValue[0] < 60 {
                    self.contact_emergency = true
                }
                if characteristicValue[0] > 210 {
                    self.contact_emergency = true
                }
                self.heart_data.append(Double(characteristicValue[0]))
            }
            print("Heartrate: \(characteristicValue[0])\n")
            
        } else if self.peripheralServices.last == "20"{
            print("Oxygen: \(characteristicValue[0])\n")
            if characteristicValue[0] != 0 {
                if characteristicValue[0] < 70 {
                    self.contact_emergency = true
                }
                self.oxygen_data.append(Double(characteristicValue[0]))
            }
        }else if characteristicValue[0] == 10{
            print(" ")
            
        }else if characteristicValue[0] == 20{
            print(" ")
        }else {
            print("Step Count: \(characteristicValue[0])\n")
            if characteristicValue[0] != 0{
                self.activity_data.append(Double(characteristicValue[0]))
            }
        }
        self.peripheralServices.append("\(characteristicValue[0])")
            
    }
}

extension BluetoothViewModel: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Arduino is powered on.")
        case .unsupported:
            print("Peripheral is unsupported.")
        case .unauthorized:
            print("Peripheral is unauthorized.")
        case .unknown:
            print("Peripheral is unknown.")
        case .resetting:
            print("Peripheral is resetting.")
        case .poweredOff:
            print("Arduino is powered off.")
        @unknown default:
            print("ERROR")
        }
    }
    
}

struct BluetoothView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    var body: some View {
        NavigationView{
            if bluetoothViewModel.peripheralServices.isEmpty != true{
                Text(bluetoothViewModel.peripheralServices[0])
                    .navigationTitle("My Devices")
            }
        }
    }
}


struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}
