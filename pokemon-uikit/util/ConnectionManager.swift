//
//  ConnectionManager.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 25.06.2024.
//

import Foundation
import Network

class ConnectionManager {
    
    static let shared = ConnectionManager()
    
    private let internetMonitor = NWPathMonitor()
    private let internetQueue = DispatchQueue(label: "InternetMonitor")
    private var hasConnectionPath = false
    
    private init() {}
    
    func startInternetTracking() {
        // only fires once
        guard internetMonitor.pathUpdateHandler == nil else {
            return
        }
        internetMonitor.pathUpdateHandler = { update in
            if update.status == .satisfied {
                print("Internet connection on.")
                self.hasConnectionPath = true
            } else {
                print("no internet connection.")
                self.hasConnectionPath = false
            }
        }
        internetMonitor.start(queue: internetQueue)
    }

    /// will tell you if the device has an Internet connection
    /// - Returns: true if there is some kind of connection
    func hasInternet() -> Bool {
        return hasConnectionPath
    }
}
