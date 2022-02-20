//
//  Constants.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit


// Callbacks
typealias CompHandler = (_ success: Bool) -> ()



// Boolean auth UserDefaults keys
let NOT_FIRST_TIME_USER = "isNotFirstTimeUser"
let PREFERRED_LANGUAGE = "preferredLanguage"



let NOTIF_DID_CONNECT_TO_INTERNET = Notification.Name("notifDidConnectToInternet")
let NOTIF_DID_DISCONNECT_TO_INTERNET = Notification.Name("notifDidDisconnectToInternet")
