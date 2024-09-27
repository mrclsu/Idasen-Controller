//
//  BluetoothManager.swift
//  Desk Controller
//
//  Created by David Williames on 11/1/21.
//

import Foundation
import CoreBluetooth


public class BluetoothManager: NSObject {
    
    public var stopOnFirstConnection = true
    
    // Singleton for managing it all
    public static let shared = BluetoothManager()
    
    public var centralManager: CBCentralManager?
    
    public var onCentralManagerStateChange: (CBCentralManager?) -> Void = { _ in }
    
    public var onConnectedPeripheralChange: (CBPeripheral?) -> Void = { _ in  }
    private var connectPeripheralRSSI: NSNumber?
    public var connectedPeripheral: CBPeripheral? // Or is currently being connected to

    
    // Not currently used... just in case I want to handle multiple desks at once
    var onAvailablePeripheralsChange: ([CBPeripheral]) -> Void = { _ in }
    private var availablePeripherals = [CBPeripheral]() {
        didSet {
            onAvailablePeripheralsChange(availablePeripherals)
        }
    }
    // It will only match if the Name contains 'Desk' in it
    var matchCriteria: (CBPeripheral) -> Bool = { peripheral in
        guard let name = peripheral.name, (name.contains("Desk") || name.contains("Alkalmatlan")) else {
            return false
        }
        
        print(peripheral.name ?? "No Name")
        print(peripheral.identifier)
        
        return true
    }
    
    override init() {
        super.init()
        startScanning()
    }
    
    public func startScanning() {
        if centralManager == nil {
            let queue = DispatchQueue(label: "BT_queue")
            centralManager = CBCentralManager(delegate: self, queue: queue)
        }
    }
    
    public func reconnect() {
        guard let peripheral = connectedPeripheral,
              peripheral.state == .disconnected else {
                  return
        }
        
        centralManager?.connect(peripheral, options: nil)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        centralManager = central
        onCentralManagerStateChange(central)
        
        guard central.state == .poweredOn else {
            return
        }
        
        if let connectedPeripheral = connectedPeripheral, connectedPeripheral.state == .disconnected {
            // Reconnect to any previous desk
            central.connect(connectedPeripheral, options: nil)
            return
        }
       
        
//        let GENERIC_ACCESS =  CBUUID(string: "00001801-0000-1000-8000-00805F9B34FB")
//        let GENERIC_ATTRIBUTE = CBUUID(string: "0000180A-0000-1000-8000-00805F9B34FB")
//        let DEVICE_INFORMATION = CBUUID(string: "99FA0001-338A-1024-8A49-009C0215F78A")
//        let CONTROL =  CBUUID(string: "99FA0010-338A-1024-8A49-009C0215F78A")
//        let CONFIGURATION = CBUUID(string: "99FA0020-338A-1024-8A49-009C0215F78A")
//        let REFERENCE_OUTPUT = CBUUID(string: "99FA0030-338A-1024-8A49-009C0215F78A")
//        let REFERENCE_INPUT = CBUUID(string: "99FA0050-338A-1024-8A49-009C0215F78A")
//        let TIMER = CBUUID(string: "FFFF0010-338A-1024-8A49-009C0215F78A")
//        let WIFI_SCAN = CBUUID(string: "FFFF0020-338A-1024-8A49-009C0215F78A")
//        let WIFI_CONNECT = CBUUID(string: "FFFF0030-338A-1024-8A49-009C0215F78A")
//        let FIRMWARE = CBUUID(string: "FFFF0100-338A-1024-8A49-009C0215F78A")
//
//        let services = [GENERIC_ACCESS, GENERIC_ATTRIBUTE, DEVICE_INFORMATION, CONTROL, CONFIGURATION, REFERENCE_OUTPUT, REFERENCE_INPUT, TIMER, WIFI_SCAN, WIFI_CONNECT, FIRMWARE]

        // Start scanning for all peripherals
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//         print("Discovered peripheral: \(peripheral) • \(advertisementData) • \(RSSI)")
        
        // Make sure it's not already connected & meets our matching criteria
        guard connectedPeripheral != peripheral, matchCriteria(peripheral) else {
            return
        }
        
        // Add it to the available peripherals if it's not already there
        if !availablePeripherals.contains(peripheral) {
            availablePeripherals.append(peripheral)
        }
        
        let isClosestMatchingPeripheral = (connectPeripheralRSSI != nil && RSSI.intValue < connectPeripheralRSSI!.intValue)
        
        // If it's the first match or it's the closest one; update the connect peripheral
        if connectedPeripheral == nil || isClosestMatchingPeripheral {
            
            // Connect to the new one
            central.connect(peripheral, options: nil)
            
            connectPeripheralRSSI = RSSI
            connectedPeripheral = peripheral
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
         print("Connected to peripheral: \(peripheral)")
        
//         Make sure it's the one we're connecting to
        guard peripheral == connectedPeripheral else {
             print("Not the one we're tracking")
            return
        }
        
        if stopOnFirstConnection {
            central.stopScan()
        }
        
        onConnectedPeripheralChange(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // print("Disconnected to peripheral: \(peripheral)")
        
        // Make sure it's the one we're connecting to
        guard peripheral == connectedPeripheral else {
             print("Not the one we're tracking")
            return
        }
        
        connectPeripheralRSSI = nil
        connectedPeripheral = nil
        
        onConnectedPeripheralChange(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // Make sure it's the one we're connecting to
        guard peripheral == connectedPeripheral else {
             print("Not the one we're tracking")
            return
        }
        
        connectPeripheralRSSI = nil
        connectedPeripheral = nil
        
        onConnectedPeripheralChange(nil)
    }
  
}
