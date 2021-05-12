//
//  ViewController.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "launchScreen")
        return iv
    }()
    
    
    private let logo: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    
    private let LOGO_WIDTH: CGFloat = 200
    private let LOGO_HEIGHT: CGFloat = 58
        
    var scaleFactor: CGFloat?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        let device = UIDevice.current.model
        if device == "iPhone" {
            scaleFactor = 11
        } else if device == "iPad" {
            scaleFactor = 22
        } else {
            scaleFactor = 30
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .AppBackgroundColor
        setupServices()
    }
    
    
    deinit {
        print("OS reclaimed memory allocated for LaunchScreenVC.")
    }

        
        
    func setupLayout() {
        
        view.addSubview(imageView)
        view.addSubview(logo)
        
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logo.widthAnchor.constraint(equalToConstant: LOGO_WIDTH).isActive = true
        logo.heightAnchor.constraint(equalToConstant: LOGO_HEIGHT).isActive = true
        
        
    }
    
    
    fileprivate func setupServices() {
        guard let isNotFirstTimeUser = SetupService.instance.isNotFirstTimeUser else { return }
        if (isNotFirstTimeUser) {
            // print("Not a first time user")
            self.animateLogoBeforePushingNewController(completion: { (_) in
                if let window = self.view.window {
                    let platformSelectionVC = UINavigationController(rootViewController: PlatformSelectionVC())
                    window.rootViewController = platformSelectionVC
                }
                
                
                
            })
        } else {
            // print("First time user")
            self.animateLogoBeforePushingNewController(completion: { (_) in
                if let window = self.view.window {
                    window.rootViewController = LanguageSelectionVC()
                }
            })
        }
    }
    
    
    
    fileprivate func animateLogoBeforePushingNewController(completion: @escaping CompHandler) {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.logo.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.8, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.logo.transform = CGAffineTransform.init(scaleX: self.scaleFactor!, y: self.scaleFactor!)
                self.imageView.alpha = 0
                self.logo.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                completion(true)
            })
        }


    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override open var shouldAutorotate: Bool {
        return false
    }

}

