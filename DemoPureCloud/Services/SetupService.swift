//
//  SetupService.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import Foundation


class SetupService {
    
    static let instance = SetupService()
    
    let defaults = UserDefaults.standard
    
    
    var isNotFirstTimeUser: Bool? {
        get {
            return defaults.bool(forKey: NOT_FIRST_TIME_USER)
        }
        set {
            defaults.set(newValue, forKey: NOT_FIRST_TIME_USER)
        }
    }
    
    
    var preferredLanguage: String? {
        get {
            return defaults.value(forKey: PREFERRED_LANGUAGE) as? String
        }
        set {
            defaults.set(newValue, forKey: PREFERRED_LANGUAGE)
        }
    }
        
        

}
