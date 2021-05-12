//
//  Constants.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit


extension UIColor {
    class var AppBackgroundColor: UIColor {
        return UIColor(red: 57/255, green: 154/255, blue: 202/255, alpha: 1)
    }

    class var regularTextColor: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }

}

// Callbacks
typealias CompHandler = (_ success: Bool) -> ()



// Boolean auth UserDefaults keys
let NOT_FIRST_TIME_USER = "isNotFirstTimeUser"
let PREFERRED_LANGUAGE = "preferredLanguage"



let NOTIF_DID_CONNECT_TO_INTERNET = Notification.Name("notifDidConnectToInternet")
let NOTIF_DID_DISCONNECT_TO_INTERNET = Notification.Name("notifDidDisconnectToInternet")
