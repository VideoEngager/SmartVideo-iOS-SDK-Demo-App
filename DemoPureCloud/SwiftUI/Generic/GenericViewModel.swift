//
//  GenericViewModel.swift
//  DemoPureCloud
//
//  Created by Slav Sarafski on 15.08.22.
//

import SwiftUI
import SmartVideoSDK

class GenericViewModel: ObservableObject {
    
    @Binding var type: PlatformType
    
    @Published var smartVideoURL = ""
    @Published var shortUrl = ""
    @Published var invitationUrl = ""
    
    @Published var showLoading = false
    
    init(type: Binding<PlatformType>) {
        self._type = type
        
        SmartVideo.delegate = self
        SmartVideo.setLogging(level: .verbose, types: [.all])
    }
    
    func call(isVideo: Bool) {
        SmartVideo.environment = .live
        let engine = GenericEngine(shortURL: self.shortUrl)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, isVideo: isVideo, lang: lang)
    }
    
    func invitationCall() {
        if self.invitationUrl.isEmpty {
            return
        }
        SmartVideo.environment = .live
        let engine = GenericEngine(environment: .live, invitationURL: self.invitationUrl)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, isVideo: false, lang: lang)
    }
    
    func back() {
        withAnimation {
            self.type = .none
        }
    }
    
    func readParameters() {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "SmartVideo-Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        else {
            return
        }

        guard let array = nsDictionary?["items"] as? [[String: Any]] else {
            return
        }
        
        for item in array {
            if let config = try? GenericConfigurations(dictionary: item) {
                if config.environment == .live
                {
                    self.smartVideoURL = config.baseURL
                    self.shortUrl  = config.agents.first?.name ?? "mobiledev"
                }
            }
        }
    }
}


extension GenericViewModel: SmartVideoDelegate {
    
    func failedEstablishCommunicationChannel(type: SmartVideoCommunicationChannelType) {
        withAnimation {
            self.showLoading = false
        }
    }
    
    func didEstablishCommunicationChannel(type: SmartVideoCommunicationChannelType) {
        withAnimation {
            self.showLoading = false
        }

        let outgoingCallVC = OutgoingCallVC()
//        outgoingCallVC.hasVideo = self.hasVideo
        outgoingCallVC.modalPresentationStyle = .fullScreen
        if let vc = UIApplication.shared.rootViewController {
            vc.present(outgoingCallVC, animated: true, completion: nil)
        }
    }
    
    func callStatusChanged(status: SmartVideoCallStatus) {
        
    }
    
    func errorHandler(error: SmartVideoError) {
        debug("SmartVideo Communication error. Error is: \(error)", level: .error, type: .genesys)
        DispatchQueue.main.async {
            withAnimation {
                self.showLoading = false
            }
            SmartVideo.callManager.hangupAndEnd()
            
            let alert = UIAlertController(title: "config_params_error_title".l10n(), message: "config_params_error_message".l10n(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "config_params_error_action".l10n(), style: UIAlertAction.Style.default, handler: nil))
            if let vc = UIApplication.shared.rootViewController {
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func onAgentTimeout() -> Bool {
        return true
    }
    
    func peerConnectionLost() {
        debug("Peer is no longer connected to the internet", level: .error, type: .genesys)
    }
}
