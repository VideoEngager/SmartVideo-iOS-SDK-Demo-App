//
//  SetupOrgParamsVC.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//


import UIKit
import AVKit
import SmartVideo
import L10n_swift


class SetupOrgParamsGenesysCloudVC: UIViewController {
    

    lazy var setupOrgParamsView: SetupOrgParamsView = {
        let lb = SetupOrgParamsView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    let envSwitch: UISwitch = {
        let sv = UISwitch()
        sv.isOn = true
        sv.setOn(true, animated: true)
        sv.isOn = false
        return sv
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
        
        setupViews()
        setupLang()
        
        setupSmartVideo()
        
        setupOrgParamsView.click2VideoButton.addTarget(self, action: #selector(click2VideoButtonDidTap), for: .touchUpInside)
        
        setupOrgParamsView.click2VoiceButton.addTarget(self, action: #selector(click2VoiceButtonDidTap), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConectionAvailable), name: NOTIF_DID_CONNECT_TO_INTERNET, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConectionNotAvailable), name: NOTIF_DID_DISCONNECT_TO_INTERNET, object: nil)
        
        
        // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        // view.addGestureRecognizer(tap)
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.AppBackgroundColor
        
        let isStaging: Bool = envSwitch.isOn
        if isStaging {
            setupOrgParamsView.environment = .staging
            setupOrgParamsView.initParams = setupOrgParamsView.GENESYS_CLOUD_INIT_PARAMS_STAGING
            setupOrgParamsView.tableView.reloadData()
            titleLabel.text = "staging_server".l10n()
        } else {
            setupOrgParamsView.environment = .live
            setupOrgParamsView.initParams = setupOrgParamsView.GENESYS_CLOUD_INIT_PARAMS_LIVE
            setupOrgParamsView.tableView.reloadData()
            titleLabel.text = "prod_server".l10n()
        }
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: envSwitch)
        envSwitch.addTarget(self, action: #selector(self.handleEnvChange), for: .valueChanged)
        
        
        
    }
    
    
    @objc func handleEnvChange() {
        if envSwitch.isOn {
            titleLabel.text = "staging_server".l10n()
            setupOrgParamsView.environment = .staging
            setupOrgParamsView.initParams = setupOrgParamsView.GENESYS_CLOUD_INIT_PARAMS_STAGING
            setupOrgParamsView.tableView.reloadData()
        } else {
            titleLabel.text = "prod_server".l10n()
            setupOrgParamsView.environment = .live
            setupOrgParamsView.initParams = setupOrgParamsView.GENESYS_CLOUD_INIT_PARAMS_LIVE
            setupOrgParamsView.tableView.reloadData()
        }
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .AppBackgroundColor
        
        enableConnect()
    }
    
    
    deinit {
        print("OS reclaimed memory allocated for SetupOrgParamsGenesysCloudVC.")
    }
    
    
    fileprivate func setupLang() {
        setupOrgParamsView.click2VoiceButton.setTitle("start_audio_button".l10n(), for: UIControl.State.normal)
        setupOrgParamsView.click2VideoButton.setTitle("start_video_button".l10n(), for: UIControl.State.normal)
    }
    
    
    
    
    fileprivate func setupViews() {
        view.addSubview(setupOrgParamsView)
        view.addSubview(notificationInternetConnection)
        maskView.alpha = 0
        view.addSubview(maskView)
        maskView.frame = view.frame
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        

        setupOrgParamsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        setupOrgParamsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        setupOrgParamsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        setupOrgParamsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
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
        
        let environment = setupOrgParamsView.environment
        SmartVideo.environment = environment
        SmartVideo.setLogging(level: .verbose, types: [.rtc, .socket, .rest, .webRTC, .genesys, .callkit])
        SmartVideo.didEstablishCommunicationChannel = didEstablishCommunicationChannel
        
        SmartVideo.delegate = self
        
        
    }

    
    
    @objc fileprivate func click2VideoButtonDidTap() {
        
        self.disableConnect()
        activityIndicator.startAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
        }, completion: nil)
        
        var displayName = "Mobile Test User"
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = setupOrgParamsView.tableView.cellForRow(at: indexPath) as? ParamsCell {
            displayName = cell.textField.text ?? "Mobile Test User"
        }
        let environment = setupOrgParamsView.environment
        let engine = GenesysEngine(environment: environment, displayName: displayName)
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
        
        var displayName = "Mobile Test User"
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = setupOrgParamsView.tableView.cellForRow(at: indexPath) as? ParamsCell {
            displayName = cell.textField.text ?? "Mobile Test User"
        }
        let environment = setupOrgParamsView.environment
        let engine = GenesysEngine(environment: environment, displayName: displayName)
        let lang = SetupService.instance.preferredLanguage ?? "en_US"
        SmartVideo.connect(engine: engine, isVideo: false, lang: lang)
        
    
    }
    
    
    fileprivate func disableConnect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsView.click2VideoButton.isEnabled = false
                self.setupOrgParamsView.click2VoiceButton.isEnabled = false
                
                self.setupOrgParamsView.click2VideoButton.backgroundColor = .gray
                self.setupOrgParamsView.click2VideoButton.layer.borderColor = UIColor.gray.cgColor
                
                self.setupOrgParamsView.click2VoiceButton.backgroundColor = .gray
                self.setupOrgParamsView.click2VoiceButton.layer.borderColor = UIColor.gray.cgColor
            }, completion: nil)
        }
    }
    
    
    
    
    fileprivate func enableConnect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsView.click2VideoButton.isEnabled = true
                self.setupOrgParamsView.click2VoiceButton.isEnabled = true
                
                self.setupOrgParamsView.click2VideoButton.backgroundColor = .AppBackgroundColor
                self.setupOrgParamsView.click2VideoButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                
                self.setupOrgParamsView.click2VoiceButton.backgroundColor = .AppBackgroundColor
                self.setupOrgParamsView.click2VoiceButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleInternetConectionAvailable() {
        // print("Connected to internet")
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsView.click2VideoButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                self.setupOrgParamsView.click2VideoButton.backgroundColor = UIColor.AppBackgroundColor
                self.setupOrgParamsView.click2VideoButton.isEnabled = true
                self.setupOrgParamsView.click2VoiceButton.layer.borderColor = UIColor.AppBackgroundColor.cgColor
                self.setupOrgParamsView.click2VoiceButton.backgroundColor = UIColor.AppBackgroundColor
                self.setupOrgParamsView.click2VoiceButton.isEnabled = true
                self.notificationInternetConnection.alpha = 0
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleInternetConectionNotAvailable() {
        // print("NOT connected to internet")
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.setupOrgParamsView.click2VideoButton.layer.borderColor = UIColor.lightGray.cgColor
                self.setupOrgParamsView.click2VideoButton.backgroundColor = UIColor.lightGray
                self.setupOrgParamsView.click2VideoButton.isEnabled = false
                self.setupOrgParamsView.click2VoiceButton.layer.borderColor = UIColor.lightGray.cgColor
                self.setupOrgParamsView.click2VoiceButton.backgroundColor = UIColor.lightGray
                self.setupOrgParamsView.click2VoiceButton.isEnabled = false
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




extension SetupOrgParamsGenesysCloudVC: SmartVideoDelegate {
    
    func didEstablishCommunicationChannel() {
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
    
    func isConnectedToInternet(isConnected: Bool) {
        if isConnected {
            print("Mobile SDK is connected to internet")
        } else {
            print("Mobile SDK is not connected to internet")
        }
    }
    
    
    func errorHandler(error: SmartVideoError) {
        print("SmartVideo Communication error. Error is: \(error)")
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
        print("Peer is no longer connected to the internet")
    }
}



