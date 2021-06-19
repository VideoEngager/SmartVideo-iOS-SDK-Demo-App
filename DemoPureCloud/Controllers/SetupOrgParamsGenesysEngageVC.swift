//
//  SetupOrgParamsGenesysEngageVC.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit
import AVKit
import SmartVideo


class SetupOrgParamsGenesysEngageVC: UIViewController {
    
    // default values for mandatory params
    private let first_name = ""
    private let last_name = ""
    private let email = ""
    private let subject = ""
    
    
    lazy var setupOrgParamsEngageView: SetupOrgParamsEngageView = {
        let lb = SetupOrgParamsEngageView()
        lb.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        setupViews()
        setupLang()
        
        setupSmartVideo()
        
        setupOrgParamsEngageView.click2VideoButton.addTarget(self, action: #selector(click2VideoButtonDidTap), for: .touchUpInside)
        setupOrgParamsEngageView.click2VoiceButton.addTarget(self, action: #selector(click2VoiceButtonDidTap), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConectionAvailable), name: NOTIF_DID_CONNECT_TO_INTERNET, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConectionNotAvailable), name: NOTIF_DID_DISCONNECT_TO_INTERNET, object: nil)
        

        setupOrgParamsEngageView.first_name = self.first_name
        setupOrgParamsEngageView.last_name = self.last_name
        setupOrgParamsEngageView.email = self.email
        setupOrgParamsEngageView.subject = self.subject
        setupOrgParamsEngageView.GENESYS_ENGAGE_INIT_PARAMS_LIVE[2] = setupOrgParamsEngageView.first_name
        setupOrgParamsEngageView.GENESYS_ENGAGE_INIT_PARAMS_LIVE[3] = setupOrgParamsEngageView.last_name
        setupOrgParamsEngageView.GENESYS_ENGAGE_INIT_PARAMS_LIVE[4] = setupOrgParamsEngageView.email
        setupOrgParamsEngageView.GENESYS_ENGAGE_INIT_PARAMS_LIVE[5] = setupOrgParamsEngageView.subject
        setupOrgParamsEngageView.initParams = setupOrgParamsEngageView.GENESYS_ENGAGE_INIT_PARAMS_LIVE
        setupOrgParamsEngageView.tableView.reloadData()
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.AppBackgroundColor
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .AppBackgroundColor
        
        enableConnect()
    }
    
        
    deinit {
        print("OS reclaimed memory allocated for SetupOrgParamsGenesysEngageVC.")
    }
    
    
    fileprivate func setupViews() {
        
        view.addSubview(setupOrgParamsEngageView)
        view.addSubview(notificationInternetConnection)
        maskView.alpha = 0
        view.addSubview(maskView)
        maskView.frame = view.frame
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        

        setupOrgParamsEngageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        setupOrgParamsEngageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        setupOrgParamsEngageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        setupOrgParamsEngageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        
        notificationInternetConnection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        notificationInternetConnection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        notificationInternetConnection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        notificationInternetConnection.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
    }
    
    
    fileprivate func setupLang() {
        setupOrgParamsEngageView.click2VoiceButton.setTitle("start_audio_button".l10n(), for: UIControl.State.normal)
        setupOrgParamsEngageView.click2VideoButton.setTitle("start_video_button".l10n(), for: UIControl.State.normal)
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
        SmartVideo.setLogging(level: .verbose, types: [.rtc, .socket, .rest, .webRTC, .genesysEngage, .callkit])
        SmartVideo.didEstablishCommunicationChannel = didEstablishCommunicationChannel
        
        
    }
    
    
    @objc fileprivate func click2VoiceButtonDidTap() {
        
        self.disableConnect()
        self.hasVideo = false

        let isCallAllowed = checkAndFetchMostRecentParams()
        if isCallAllowed {
            self.activityIndicator.startAnimating()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maskView.alpha = 1
            }, completion: nil)

            // Required ONLY if SmartVideo config params need to be editable from inside host/demo app.
            GenesysEngage.shared.updateConfiguration(configuration: GenesysEngageConfigurations(environment: .live,
                                                                                                engineURL: "videome.leadsecure.com",
                                                                                                chatURL: "\(setupOrgParamsEngageView.server_url):443",
                                                                                                serverBaseURL: setupOrgParamsEngageView.server_url,
                                                                                                service: setupOrgParamsEngageView.service_name,
                                                                                                agentURL: setupOrgParamsEngageView.agent_url,
                                                                                                authorizationValue: setupOrgParamsEngageView.authorization_value))
            let engine = GenesysEngageEngine(environment: setupOrgParamsEngageView.environment,
                                             shortURL: setupOrgParamsEngageView.agent_url,
                                             firstName: setupOrgParamsEngageView.first_name,
                                             lastName: setupOrgParamsEngageView.last_name,
                                             email: setupOrgParamsEngageView.email,
                                             subject: setupOrgParamsEngageView.subject)
            let lang = SetupService.instance.preferredLanguage ?? "en_US"
            SmartVideo.connect(engine: engine, isVideo: false, lang: lang)

        } else {
            let errMsg = "param_error_message".l10n()
            self.showErrorMessage(errorMessage: errMsg)
        }
        
    
    }
    
    
    
    @objc fileprivate func click2VideoButtonDidTap() {
        self.disableConnect()
        self.hasVideo = true

        let isCallAllowed = checkAndFetchMostRecentParams()
        if isCallAllowed {
            self.activityIndicator.startAnimating()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maskView.alpha = 1
            }, completion: nil)

            // Required ONLY if SmartVideo config params need to be editable from inside host/demo app.
            GenesysEngage.shared.updateConfiguration(configuration: GenesysEngageConfigurations(environment: .live,
                                                                                                engineURL: "videome.leadsecure.com",
                                                                                                chatURL: "\(setupOrgParamsEngageView.server_url):443",
                                                                                                serverBaseURL: setupOrgParamsEngageView.server_url,
                                                                                                service: setupOrgParamsEngageView.service_name,
                                                                                                agentURL: setupOrgParamsEngageView.agent_url,
                                                                                                authorizationValue: setupOrgParamsEngageView.authorization_value))
            let engine = GenesysEngageEngine(environment: setupOrgParamsEngageView.environment,
                                             shortURL: setupOrgParamsEngageView.agent_url,
                                             firstName: setupOrgParamsEngageView.first_name,
                                             lastName: setupOrgParamsEngageView.last_name,
                                             email: setupOrgParamsEngageView.email,
                                             subject: setupOrgParamsEngageView.subject)
            let lang = SetupService.instance.preferredLanguage ?? "en_US"
            SmartVideo.connect(engine: engine, isVideo: true, lang: lang)

        } else {
            let errMsg = "param_error_message".l10n()
            self.showErrorMessage(errorMessage: errMsg)
        }
        
    }
    
    
    
    fileprivate func checkAndFetchMostRecentParams() -> Bool {
        
        var isAllowedToPlaceCall: Bool = true
        for i in 0...setupOrgParamsEngageView.NUM_ROWS-1 {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell: ParamsCellEngage = setupOrgParamsEngageView.tableView.cellForRow(at: indexPath) as? ParamsCellEngage else { return false }
            if let text = cell.textField.text {
                if !text.isEmpty {
                    if i == 0 {
                        setupOrgParamsEngageView.server_url = text
                    } else if i == 1 {
                        setupOrgParamsEngageView.agent_url = text
                    } else if i == 2 {
                        setupOrgParamsEngageView.first_name = text
                    } else if i == 3 {
                        setupOrgParamsEngageView.last_name = text
                    } else if i == 4 {
                        setupOrgParamsEngageView.email = text
                    } else if i == 5 {
                        setupOrgParamsEngageView.subject = text
                    } else if i == 6 {
                        setupOrgParamsEngageView.service_name = text
                    } else if i == 7 {
                        setupOrgParamsEngageView.authorization_value = text
                    }
                } else {
                    if i != setupOrgParamsEngageView.NUM_ROWS - 1 {
                        isAllowedToPlaceCall = false
                    }
                }
            } else {
                if i != setupOrgParamsEngageView.NUM_ROWS - 1 {
                    isAllowedToPlaceCall = false
                }
            }
        }
        return isAllowedToPlaceCall
        
    }
    
    
    fileprivate func disableConnect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsEngageView.click2VideoButton.isEnabled = false
                self.setupOrgParamsEngageView.click2VoiceButton.isEnabled = false

                self.setupOrgParamsEngageView.click2VideoButton.backgroundColor = .gray
                self.setupOrgParamsEngageView.click2VideoButton.layer.borderColor = UIColor.gray.cgColor

                self.setupOrgParamsEngageView.click2VoiceButton.backgroundColor = .gray
                self.setupOrgParamsEngageView.click2VoiceButton.layer.borderColor = UIColor.gray.cgColor
            }, completion: nil)
        }
    }
    
    
    
    
    fileprivate func enableConnect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsEngageView.click2VideoButton.isEnabled = true
                self.setupOrgParamsEngageView.click2VoiceButton.isEnabled = true

                self.setupOrgParamsEngageView.click2VideoButton.backgroundColor = .AppBackgroundColor
                self.setupOrgParamsEngageView.click2VideoButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor

                self.setupOrgParamsEngageView.click2VoiceButton.backgroundColor = .AppBackgroundColor
                self.setupOrgParamsEngageView.click2VoiceButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
            }, completion: nil)
        }
    }
    
    
    fileprivate func showErrorMessage(errorMessage: String) {
        let alertController: UIAlertController = UIAlertController(title: "param_error_title".l10n(), message: errorMessage, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "param_error_button".l10n(), style: .default) { (_) -> Void in
            self.enableConnect()
        }
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleInternetConectionAvailable() {
    DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsEngageView.click2VideoButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                self.setupOrgParamsEngageView.click2VideoButton.backgroundColor = UIColor.AppBackgroundColor
                self.setupOrgParamsEngageView.click2VideoButton.isEnabled = true
                self.setupOrgParamsEngageView.click2VoiceButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                self.setupOrgParamsEngageView.click2VoiceButton.backgroundColor = UIColor.AppBackgroundColor
                self.setupOrgParamsEngageView.click2VoiceButton.isEnabled = true
                self.notificationInternetConnection.alpha = 0
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleInternetConectionNotAvailable() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsEngageView.click2VideoButton.layer.borderColor = UIColor.lightGray.cgColor
                self.setupOrgParamsEngageView.click2VideoButton.backgroundColor = UIColor.lightGray
                self.setupOrgParamsEngageView.click2VideoButton.isEnabled = false
                self.setupOrgParamsEngageView.click2VoiceButton.layer.borderColor = UIColor.lightGray.cgColor
                self.setupOrgParamsEngageView.click2VoiceButton.backgroundColor = UIColor.lightGray
                self.setupOrgParamsEngageView.click2VoiceButton.isEnabled = false
                self.notificationInternetConnection.alpha = 1
            }, completion: nil)
        }
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.isHidden = true
        SmartVideo.callManager.hangup()
//        SmartVideo.callManager.hangupAndEnd()
    }
    
    
    override open var shouldAutorotate: Bool {
        return false
    }
    

}

extension SetupOrgParamsGenesysEngageVC: SmartVideoDelegate {
    
    func didEstablishCommunicationChannel() {
        activityIndicator.stopAnimating()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 0
        }, completion: nil)
        
        let outgoingCallVC = OutgoingCallVC()
        outgoingCallVC.hasVideo = true//self.hasVideo
        outgoingCallVC.modalPresentationStyle = .fullScreen
        self.present(outgoingCallVC, animated: true, completion: nil)
    }
    
    func isConnectedToInternet(isConnected: Bool) {
        if isConnected {
            debug("Connected to internet", level: .info, type: .genesysEngage)
        } else {
            debug("Not connected to internet", level: .error, type: .genesysEngage)
        }
    }
    
    
    func errorHandler(error: SmartVideoError) {
        debug("SmartVideo Communication error. Error is: \(error)", level: .error, type: .genesysEngage)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maskView.alpha = 0
            }, completion: nil)
            SmartVideo.callManager.hangupAndEnd()

            let alert = UIAlertController(title: "config_params_error_title".l10n(), message: "config_params_error_message".l10n(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "config_params_error_action".l10n(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func peerConnectionLost() {
        debug("Peer is no longer connected to the internet", level: .error, type: .genesysEngage)
    }
    
    
    
    func genesysEngageChat(message: String, from: String) {
        debug("Incoming text message from \(from): \(message)", level: .info, type: .genesysEngage)
    }
    
}
