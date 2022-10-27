//
//  PlatformViewModel.swift
//  DemoPureCloud
//
//  Created by Slav Sarafski on 15.08.22.
//

import SwiftUI
import SmartVideoSDK

class GenesysCloudViewModel: ObservableObject {
    
    @Binding var type: PlatformType
    
    @Published var customParams = false
    @Published var environment = Environment.live
    @Published var environmentBool = true {
        didSet {
            self.environment = environmentBool ? .live : .staging
        }
    }
    
    @Published var smartVideoURL = ""
    @Published var environmentURL = ""
    @Published var organizationID = ""
    @Published var deploymentID = ""
    @Published var queue = ""
    
    @Published var tenant = ""
    
    @Published var customerFirstName = "Slav"
    @Published var customerLastName = "Sarafski"
    
    @Published var showLoading = false
    
    init(type: Binding<PlatformType>) {
        self._type = type
        
        SmartVideo.delegate = self
        SmartVideo.chatDelegate = self
        SmartVideo.setLogging(level: .verbose, types: [.all])
    }
    
    func back() {
        withAnimation {
            self.type = .none
        }
    }
    
    
    
    func call(isVideo: Bool) {
        let avatarImageUrl = "https://videoengager.com"
        let urlClient = "https://my_url_client"
        let videocall_flag = true
        let audioonlycall_flag = false
        let chatonly_flag = false
        
        let customFields = ["firstName": self.customerFirstName,
                            "lastName": self.customerLastName,
                            "urlclient": urlClient,
                            "videocall": videocall_flag,
                            "audioonlycall": audioonlycall_flag,
                            "chatonly": chatonly_flag] as [String : Any]
        let memberInfo = ["displayName": self.customerFirstName + " " + self.customerLastName,
                          "avatarImageUrl": avatarImageUrl,
                          "customFields": customFields] as [String : Any]
        
        var configurations: GenesysConfigurations?
        if self.customParams {
            configurations = GenesysConfigurations(environment: self.environment,
                                                   organizationID: self.organizationID,
                                                   deploymentID: self.deploymentID,
                                                   tenantId: self.tenant,
                                                   environmentURL: self.environmentURL,
                                                   queue: self.queue,
                                                   engineUrl: self.smartVideoURL)
        }
        
        let engine = GenesysEngine(environment: environment, isVideo: isVideo, configurations: configurations, memberInfo: memberInfo)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, isVideo: isVideo, lang: lang)
        
        withAnimation {
            self.showLoading = true
        }
    }
    
    func chat() {
        let avatarImageUrl = "https://videoengager.com"
        let urlClient = "https://my_url_client"
        let videocall_flag = false
        let audioonlycall_flag = false
        let chatonly_flag = true
        
        let customFields = ["firstName": self.customerFirstName,
                            "lastName": self.customerLastName,
                            "urlclient": urlClient,
                            "videocall": videocall_flag,
                            "audioonlycall": audioonlycall_flag,
                            "chatonly": chatonly_flag] as [String : Any]
        let memberInfo = ["displayName": self.customerFirstName + " " + self.customerLastName,
                          "avatarImageUrl": avatarImageUrl,
                          "customFields": customFields] as [String : Any]
        
        var configurations: GenesysConfigurations?
        if self.customParams {
            configurations = GenesysConfigurations(environment: self.environment,
                                                   organizationID: self.organizationID,
                                                   deploymentID: self.deploymentID,
                                                   tenantId: self.tenant,
                                                   environmentURL: self.environmentURL,
                                                   queue: self.queue,
                                                   engineUrl: self.smartVideoURL)
        }
        
        let engine = GenesysEngine(environment: environment, commType: .chat, configurations: configurations, memberInfo: memberInfo)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, lang: lang)
        
        withAnimation {
            self.showLoading = true
        }
    }
    
    func readParameters() {
        SmartVideo.chatDelegate = self
        
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
            if let config = try? GenesysConfigurations(dictionary: item),
               self.type == .cloud {
                if config.environment == .live,
                   self.environment == .live
                {
                    self.deploymentID = config.deploymentID
                    self.organizationID = config.organizationID
                    self.smartVideoURL = config.engineUrl
                    self.environmentURL = config.environmentURL
                    self.queue = config.queue
                    self.tenant = config.tenantId
                }
                if config.environment == .staging,
                   self.environment == .staging
                {
                    self.deploymentID = config.deploymentID
                    self.organizationID = config.organizationID
                    self.smartVideoURL = config.engineUrl
                    self.environmentURL = config.environmentURL
                    self.queue = config.queue
                    self.tenant = config.tenantId
                }
            }
        }
    }
}

extension GenesysCloudViewModel: SmartVideoDelegate {
    
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

extension GenesysCloudViewModel: SmartVideoChatDelegate {
    
    func chatStatusChanged(status: SmartVideoChatStatus) {
        if status == .agentAnswered {
            DispatchQueue.main.async {
                withAnimation {
                    self.showLoading = false
                }
                let chatVC = ChatVC()
                chatVC.modalPresentationStyle = .fullScreen
                SmartVideo.chatDelegate = nil
                if let vc = UIApplication.shared.rootViewController {
                    vc.present(chatVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension UIApplication {
    var rootViewController: UIViewController? {
        var topController = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first?
            .rootViewController
        
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
