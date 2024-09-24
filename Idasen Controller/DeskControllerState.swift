//
//  DeskControllerState.swift
//  Idasen Controller
//
//  Created by Marcell Schuh on 9/24/24.
//

import Foundation
import CoreBluetooth

class DeskControllerState: ObservableObject {
    private var peripheral: DeskPeripheral? {
        didSet {
            guard let desk = peripheral else {return}
            self.name = desk.peripheral.name 
            self.deskController = DeskController(desk: desk)
        }
    }
    
    @Published var deskController: DeskController? {
        didSet {
            deskController?.onPositionChange { pos in
                DispatchQueue.main.async {
                    self.position = pos
                }
            }
        }
    }
    @Published var name: String? = nil
    @Published var position: Float? = nil
    
    init() {
        onPeripheralChanged(perf: BluetoothManager.shared.connectedPeripheral)
        BluetoothManager.shared.onConnectedPeripheralChange = onPeripheralChanged
    }
    
        
    private func onPeripheralChanged(perf: CBPeripheral?) {
        DispatchQueue.main.async {
            if let perf = perf {
                self.peripheral = DeskPeripheral(peripheral: perf)
            } else {
                self.peripheral = nil
            }
        }
    }

}
