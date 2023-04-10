//
//  CBUUIDs.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-04-04.
//

import Foundation
import CoreBluetooth

struct CBUUIDs {
    static let kBLEService_UUID = "2A57"
    static let kBLE_Characteristic_uuid_Tx = "A336BFE9-DFC2-53DE-6C91-A5559CDC6028"
    static let kBLE_Characteristic_uuid_Rx = "A336BFE9-DFC2-53DE-6C91-A5559CDC6028"
    
    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx) //write
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx) // read
}
