//
//  LanguageSelectionVC.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit
import ShimmerSwift
import L10n_swift

class LanguageSelectionVC: UIViewController {
    
    var currentLanguage = "en_US"
    var selectedLanguage = "en_US"
    
    let supportedLang1 = "en_US"
    let supportedLang2 = "pt_PT"
    let supportedLang3 = "bg_BG"
    let supportedLang4 = "es_ES"
    let supportedLang5 = "de_DE"


    
    let helloLabel: UILabel = {
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.text = "Hello"
        hl.textColor = UIColor.regularTextColor
        hl.font? = UIFont.boldSystemFont(ofSize: 64)
        hl.textAlignment = .center
        return hl
    }()
    
    
    let shimmerView: ShimmeringView = {
        let sv = ShimmeringView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isUserInteractionEnabled = true
        return sv
    }()
    
    
    let languageSelector: UILabel = {
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.text = ">>>   Slide to select English"
        hl.textColor = UIColor.regularTextColor
        hl.font? = UIFont.systemFont(ofSize: 22)
        hl.numberOfLines = 0
        hl.textAlignment = .center
        hl.sizeToFit()
        return hl
    }()
    
    
    
    private var timer = Timer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .AppBackgroundColor
        
        
        setupView()
        
        let panRightToSelect = UIPanGestureRecognizer(target: self, action: #selector(handleLanguageDidSelect(sender:)))
        shimmerView.addGestureRecognizer(panRightToSelect)
        
        shimmerView.isShimmering = true
        
   
    }
    
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        runTimer()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    
    deinit {
        print("OS reclaimed memory allocated for LanguageSelectionVC.")
    }
    
    
    
    fileprivate func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeLanguageInView), userInfo: nil, repeats: true)
    }
    
    
    fileprivate func stopTimer() {
        timer.invalidate()
    }
    

    
    @objc fileprivate func changeLanguageInView() {

        if currentLanguage == supportedLang1 {
            selectedLanguage = supportedLang1
            currentLanguage = supportedLang2
            helloLabel.text = "Hello"
            languageSelector.text = ">>>   Slide to select English"
            languageSelector.sizeToFit()
        } else if currentLanguage == supportedLang2 {
            selectedLanguage = supportedLang2
            currentLanguage = supportedLang3
            helloLabel.text = "Olá"
            languageSelector.text = ">>>   Deslize para selecionar Português"
            languageSelector.sizeToFit()
        } else if currentLanguage == supportedLang3 {
            selectedLanguage = supportedLang3
            currentLanguage = supportedLang4
            helloLabel.text = "Здравейте"
            languageSelector.text = ">>>   Плъзнете за да избере Български"
            languageSelector.sizeToFit()
        } else if currentLanguage == supportedLang4 {
            selectedLanguage = supportedLang4
            currentLanguage = supportedLang5
            helloLabel.text = "Hola"
            languageSelector.text = ">>>   Deslice para seleccionar español"
            languageSelector.sizeToFit()
        } else if currentLanguage == supportedLang5 {
            selectedLanguage = supportedLang5
            currentLanguage = supportedLang1
            helloLabel.text = "Hallo"
            languageSelector.text = ">>>   Schieben Sie, um Deutsch auszuwählen"
            languageSelector.sizeToFit()
        }

    }
    
    
    fileprivate func setupView() {
        view.addSubview(helloLabel)
        view.addSubview(shimmerView)
        
        helloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        helloLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        helloLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
        shimmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        shimmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        shimmerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        shimmerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        shimmerView.contentView = languageSelector
        
    }
    

    
    @objc fileprivate func handleLanguageDidSelect(sender: UIPanGestureRecognizer) {
        
        stopTimer()

        if sender.state == .began {
            return
        } else if sender.state == .changed {
            return
        } else if sender.state == .ended {

            let translationX = sender.translation(in: view).x
            let velocity = sender.velocity(in: view).x
            
            if translationX > 100 && velocity > 500 {
                selectLanguage(selectedLanguage)
            } else {
                return
            }
        }
    }
    
    
    fileprivate func selectLanguage(_ lang: String) {
        L10n.shared.language = lang
        SetupService.instance.preferredLanguage = lang
        NotificationCenter.default.post(name: .L10nLanguageChanged, object: nil)
        
        if let window = self.view.window {
            SetupService.instance.isNotFirstTimeUser = true
            let platformSelectionVC = UINavigationController(rootViewController: PlatformSelectionVC())
            window.rootViewController = platformSelectionVC
        }

    }
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
}


extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
    
}
