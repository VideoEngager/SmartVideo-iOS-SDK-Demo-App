//
//  SetupOrgParamsGenericVC.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit
import AVKit
import SmartVideoSDK


class SetupOrgParamsGenericVC: UIViewController {
    
    // Please replace with the shortUrl for your account
    let shortUrl = "pureclouddemo"

    
    let click2VideoButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.layer.cornerRadius = 10
        lb.layer.borderColor = UIColor.gray.cgColor
        lb.backgroundColor = UIColor.gray
        lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        lb.setTitleColor(UIColor.white, for: UIControl.State.normal)
        lb.isEnabled = false
        return lb
    }()
    
    
    
    let click2VoiceButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.layer.cornerRadius = 10
        lb.layer.borderColor = UIColor.gray.cgColor
        lb.backgroundColor = UIColor.gray
        lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        lb.setTitleColor(UIColor.white, for: UIControl.State.normal)
        lb.isEnabled = false
        return lb
    }()
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.isHidden = true
        ai.color = UIColor.darkGray
        ai.style = UIActivityIndicatorView.Style.large
        return ai
    }()
    
    var maskView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    
    
    let notificationInternetConnection: NotificationInternetConnection = {
        let notif = NotificationInternetConnection()
        notif.translatesAutoresizingMaskIntoConstraints = false
        notif.alpha = 0
        return notif
    }()
    
    
    private var hasVideo: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        view.backgroundColor = .white
        
        setupViews()
        
        setupSmartVideo()
        
        click2VoiceButton.setTitle("start_audio_button".l10n(), for: UIControl.State.normal)
        click2VideoButton.setTitle("start_video_button".l10n(), for: UIControl.State.normal)
        
        click2VideoButton.addTarget(self, action: #selector(click2VideoButtonDidTap), for: .touchUpInside)
        
        click2VoiceButton.addTarget(self, action: #selector(click2VoiceButtonDidTap), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConectionAvailable), name: NOTIF_DID_CONNECT_TO_INTERNET, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConectionNotAvailable), name: NOTIF_DID_DISCONNECT_TO_INTERNET, object: nil)

        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .AppBackgroundColor
        
        enableConnect()
    }
    

    
    deinit {
        print("OS reclaimed memory allocated for SetupOrgParamsGenericVC.")
    }
    
    
    fileprivate func setupViews() {
        view.addSubview(click2VideoButton)
        view.addSubview(click2VoiceButton)
        view.addSubview(notificationInternetConnection)
        maskView.alpha = 0
        view.addSubview(maskView)
        maskView.frame = view.frame
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        

        click2VideoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        click2VideoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        click2VideoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        click2VideoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        click2VoiceButton.bottomAnchor.constraint(equalTo: click2VideoButton.topAnchor, constant: -50).isActive = true
        click2VoiceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        click2VoiceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        click2VoiceButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        notificationInternetConnection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        notificationInternetConnection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        notificationInternetConnection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        notificationInternetConnection.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    
    fileprivate func setupSmartVideo() {
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                
            }
        }
        if AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
            AVCaptureDevice.requestAccess(for: .audio) { _ in
                
            }
        }
        
        SmartVideo.environment = .live
        SmartVideo.setLogging(level: .verbose, types: [.rtc, .socket, .rest, .webRTC, .genesys, .callkit])
        
        SmartVideo.delegate = self
          
    }

    
    
    @objc fileprivate func click2VideoButtonDidTap() {
        
        self.disableConnect()
        
        activityIndicator.startAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
        }, completion: nil)
        
        SmartVideo.environment = .live
        let engine = GenericEngine(shortURL: self.shortUrl)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, isVideo: true, lang: lang)
        
        
    }
    
    
    @objc fileprivate func click2VoiceButtonDidTap() {
        
        self.disableConnect()
        self.hasVideo = false
        
        activityIndicator.startAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
        }, completion: nil)
        
        
            
        SmartVideo.environment = .live
        let engine = GenericEngine(shortURL: self.shortUrl)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, isVideo: false, lang: lang)

    
    }
    
    
    fileprivate func disableConnect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.click2VideoButton.isEnabled = false
                self.click2VoiceButton.isEnabled = false
                
                self.click2VideoButton.backgroundColor = .gray
                self.click2VideoButton.layer.borderColor = UIColor.gray.cgColor
                
                self.click2VoiceButton.backgroundColor = .gray
                self.click2VoiceButton.layer.borderColor = UIColor.gray.cgColor
            }, completion: nil)
        }
    }
    
    
    
    
    fileprivate func enableConnect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.click2VideoButton.isEnabled = true
                self.click2VoiceButton.isEnabled = true
                
                self.click2VideoButton.backgroundColor = .AppBackgroundColor
                self.click2VideoButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                
                self.click2VoiceButton.backgroundColor = .AppBackgroundColor
                self.click2VoiceButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleInternetConectionAvailable() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.click2VideoButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                self.click2VideoButton.backgroundColor = UIColor.AppBackgroundColor
                self.click2VideoButton.isEnabled = true
                self.click2VoiceButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                self.click2VoiceButton.backgroundColor = UIColor.AppBackgroundColor
                self.click2VoiceButton.isEnabled = true
                self.notificationInternetConnection.alpha = 0
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleInternetConectionNotAvailable() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.click2VideoButton.layer.borderColor = UIColor.lightGray.cgColor
                self.click2VideoButton.backgroundColor = UIColor.lightGray
                self.click2VideoButton.isEnabled = false
                self.click2VoiceButton.layer.borderColor = UIColor.lightGray.cgColor
                self.click2VoiceButton.backgroundColor = UIColor.lightGray
                self.click2VoiceButton.isEnabled = false
                self.notificationInternetConnection.alpha = 1
            }, completion: nil)
        }
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.isHidden = true
        SmartVideo.callManager.hangup()
    }
    
    
    override open var shouldAutorotate: Bool {
        return false
    }
    



}




extension SetupOrgParamsGenericVC: SmartVideoDelegate {
    
    
    func didEstablishCommunicationChannel(type: SmartVideoCommunicationChannelType) {
        print("TYPE:: \(type.rawValue)")
        if type != .chat {
            activityIndicator.stopAnimating()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maskView.alpha = 0
            }, completion: nil)

            let outgoingCallVC = OutgoingCallVC()
            outgoingCallVC.hasVideo = self.hasVideo
            outgoingCallVC.modalPresentationStyle = .fullScreen
            self.present(outgoingCallVC, animated: true, completion: nil)
        }
    }
    
    func callStatusChanged(status: SmartVideoCallStatus) {
        print("STATUS:: \(status.rawValue)")
    }
    
    
    func isConnectedToInternet(isConnected: Bool) {
        print("Test")
        if isConnected {
            debug("Connected to internet", level: .info, type: .generic)
        } else {
            debug("Not connected to internet", level: .error, type: .generic)
        }
    }
    
    
    func errorHandler(error: SmartVideoError) {
        debug("SmartVideo Communication error. Error is: \(error)", level: .error, type: .generic)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maskView.alpha = 0
            }, completion: nil)
            SmartVideo.callManager.hangupAndEnd()
            
            let alert = UIAlertController(title: "config_params_error_title".l10n(),
                                          message: error.error,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "config_params_error_action".l10n(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func peerConnectionLost() {
        debug("Peer is no longer connected to the internet", level: .error, type: .generic)
    }
    
}

