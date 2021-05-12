//
//  Helpers.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import SystemConfiguration
import Network
import Foundation


class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                // print("We're connected!")
                NotificationCenter.default.post(name: NOTIF_DID_CONNECT_TO_INTERNET, object: nil)
            } else {
                // print("No connection.")
                NotificationCenter.default.post(name: NOTIF_DID_DISCONNECT_TO_INTERNET, object: nil)

            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
//        print("Networking monitoring will be stopped")
        monitor.cancel()
    }
}



