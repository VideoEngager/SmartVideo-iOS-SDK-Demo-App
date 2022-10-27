//
//  GenesysEngageViewModel.swift
//  DemoPureCloud
//
//  Created by Slav Sarafski on 15.08.22.
//

import SwiftUI
import SmartVideoSDK

class GenesysEngageViewModel: ObservableObject {
    
    @Binding var type: PlatformType
    
    init(type: Binding<PlatformType>) {
        self._type = type
        
//        SmartVideo.delegate = self
//        SmartVideo.chatDelegate = self
        SmartVideo.setLogging(level: .verbose, types: [.all])
    }
    
    func back() {
        withAnimation {
            self.type = .none
        }
    }
}
