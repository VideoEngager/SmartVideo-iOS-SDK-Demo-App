//
//  PlatformSelection.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit
import SmartVideoSDK


let imageCache = NSCache<AnyObject, AnyObject>()


class ChatVC: UIViewController, UITextFieldDelegate {


    lazy var chatView: ChatView = {
        let cv = ChatView()
        cv.chatTableView.backgroundColor = .white
        cv.chatTextField.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var messages: [ChatMessage] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLang()
        
        view.backgroundColor = UIColor.white
        
        
        SmartVideo.chatDelegate = self
        
        if let genesysMemberInfo = GenesysAgentData.shared.memberInfo {
            updateAgentInfo(agentInfo: genesysMemberInfo)
        }
        
        
        self.dismissKeyboardWhenTappedAround()
        
        
    }
    
    
    
    fileprivate func setupLang() {
        let endChat = "end_chat".l10n()
        let msgPlaceholder = "type_message".l10n()
        
        chatView.closeChatButton.setTitle(endChat, for: .normal)
        chatView.chatTextField.attributedPlaceholder = NSAttributedString(string: msgPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    fileprivate func setupView() {
        self.view.addSubview(chatView)
        
        chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chatView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        if #available(iOS 15.0, *) {
            chatView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        } else {
            chatView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        chatView.chatSendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        chatView.closeChatButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    
    @objc fileprivate func sendMessage() {
        if let text = chatView.chatTextField.text,
           text.count > 0 {
            chatView.chatTextField.text = ""
            let message = ChatMessage(message: text, date: Date(), sender: chatView.memberID)
            SmartVideo.sendGenesysCloudChat(message: message)
        }
    }
    
    
    @objc fileprivate func close() {
        SmartVideo.disconnect()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateAgentInfo(agentInfo: GenesysAgentInfo) {
//        print("updateAgentInfo")
        DispatchQueue.main.async {
            self.chatView.memberID = agentInfo.id
            if let dn = agentInfo.displayName {
                if dn.isEmpty {
                    self.chatView.headerTitle.text = "Agent"
                    self.chatView.displayName = "Agent"
                } else {
                    self.chatView.displayName = dn
                    self.chatView.headerTitle.text = dn
                }
            } else {
                self.chatView.headerTitle.text = "Agent"
                self.chatView.displayName = "Agent"
            }
            if let imgUrl = agentInfo.avatarImageUrl {
                if !imgUrl.isEmpty {
                    if imgUrl.canOpenUrl() {
                        if let imgFromCache = imageCache.object(forKey: imgUrl as AnyObject) as? UIImage {
                            // Cache hit, loading image from cache
                            self.chatView.avatarImage = imgFromCache
                        } else {
                            // Cache miss
                            if let url = URL(string: imgUrl) {
                                let config = URLSessionConfiguration.default
                                let session = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: nil)
                                
                                session.dataTask(with: url) { data, response, error in
                                    if let err = error {
                                        debug("Error when trying to download agent avatar image. Error is \(err)", level: .error, type: .genesys)
                                    }
                                    DispatchQueue.main.async {
                                        if let safeData = data {
                                            if let image = UIImage(data: safeData) {
                                                self.chatView.avatarImage = image
                                            }
                                        }
                                    }
                                }.resume()
                            }
                        }
                    }
                }
            }
        }

        
    }
    
    
    func updateChat(messages: [ChatMessage]) {
        chatView.headerTitle.text = chatView.displayName
        chatView.messages = messages
        chatView.chatTableView.reloadData()
        chatView.chatTableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .bottom, animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        chatView.chatTextField.endEditing(true)
        return false
    }
    
    deinit {
        print("OS reclaimed memory allocated for ChatVC.")
    }
    
}




extension ChatVC: SmartVideoChatDelegate {
    
//    func chatStatusChanged(status: SmartVideoChatStatus) {
//        print("CHAT STATUS:: \(status.rawValue)")
//    }
    
    
    func genesysCloudChat(message: ChatMessage) {
        messages.append(message)
        updateChat(messages: messages)
    }
    
    func endChat() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func errorHandler(error: SmartVideoError) {
        debug("SmartVideo Chat error. Error is: \(error)", level: .error, type: .genesys)
        
    }
}

