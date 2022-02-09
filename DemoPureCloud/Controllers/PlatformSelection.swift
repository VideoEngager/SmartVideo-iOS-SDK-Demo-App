//
//  PlatformSelection.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit


class PlatformSelectionVC: UIViewController {
    
    
    let genericButton: UIButton = {
        let ib = UIButton()
        ib.translatesAutoresizingMaskIntoConstraints = false
        ib.setImage(UIImage(named: "generic"), for: UIControl.State.normal)
        ib.imageView?.contentMode = .scaleAspectFit
        ib.imageEdgeInsets = UIEdgeInsets(top: 4, left: 7, bottom: 4, right: 7)
        ib.isEnabled = true
        return ib
    }()
    
    
    
    let genesysCloudButton: UIButton = {
        let ib = UIButton()
        ib.translatesAutoresizingMaskIntoConstraints = false
        ib.setImage(UIImage(named: "genesys-cloud"), for: UIControl.State.normal)
        ib.imageView?.contentMode = .scaleAspectFit
        ib.imageEdgeInsets = UIEdgeInsets(top: 4, left: 7, bottom: 4, right: 7)
        ib.isEnabled = true
        return ib
    }()
    
    
    let genesysEngageButton: UIButton = {
        let ib = UIButton()
        ib.translatesAutoresizingMaskIntoConstraints = false
        ib.setImage(UIImage(named: "genesys-engage"), for: UIControl.State.normal)
        ib.imageView?.contentMode = .scaleAspectFit
        ib.imageEdgeInsets = UIEdgeInsets(top: 4, left: 7, bottom: 4, right: 7)
        ib.isEnabled = true
        return ib
    }()
    
    private let copyrightText: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor? = UIColor.clear
        nl.textColor = UIColor.AppBackgroundColor
        nl.text = "© 2022 VideoEngager, Inc."
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.numberOfLines = 0
        nl.textAlignment = .right
        nl.sizeToFit()
        return nl
    }()
    
    
    private let appCurrentVersionLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor? = UIColor.clear
        nl.textColor = UIColor.AppBackgroundColor
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.numberOfLines = 0
        nl.textAlignment = .left
        nl.sizeToFit()
        return nl
    }()
    
    
    private let sdkCurrentVersionLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor? = UIColor.clear
        nl.textColor = UIColor.AppBackgroundColor
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.numberOfLines = 0
        nl.textAlignment = .left
        nl.sizeToFit()
        return nl
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        setupViews()
        setupLang()
        
        genericButton.addTarget(self, action: #selector(handleGeneric), for: .touchUpInside)
        genesysCloudButton.addTarget(self, action: #selector(handleGenesysCloud), for: .touchUpInside)
        genesysEngageButton.addTarget(self, action: #selector(handleGenesysEngage), for: .touchUpInside)

        let localizedBackButton = "backButtonItem".l10n()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: localizedBackButton, style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.setupLang), name: .L10nLanguageChanged, object: nil
        )
        
        
        
    }
    
    
    @objc private func handleGeneric() {
        
        let setupOrgParamsGenericVC = SetupOrgParamsGenericVC()
        navigationController?.pushViewController(setupOrgParamsGenericVC, animated: true)
        
    }
    
    
    @objc private func handleGenesysCloud() {
        
        let setupOrgParamsGenesysCloudVC = SetupOrgParamsGenesysCloudVC()
        navigationController?.pushViewController(setupOrgParamsGenesysCloudVC, animated: true)
        
    }
    
    
    @objc private func handleGenesysEngage() {
        
        let setupOrgParamsGenesysEngageVC = SetupOrgParamsGenesysEngageVC()
        navigationController?.pushViewController(setupOrgParamsGenesysEngageVC, animated: true)
        
    }
    
    
    
    @objc fileprivate func setupLang() {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appCurrentVersionLabel.text = "app_version".l10n() + " " + appVersion
        }
        
        let sdkVersion = "1.3.4"
        sdkCurrentVersionLabel.text = "sdk_version".l10n() + " " + sdkVersion
    
        
    }
    
    
    fileprivate func setupViews() {
        
        view.addSubview(genericButton)
        view.addSubview(genesysCloudButton)
        view.addSubview(genesysEngageButton)
        view.addSubview(copyrightText)
        view.addSubview(appCurrentVersionLabel)
        view.addSubview(sdkCurrentVersionLabel)
        
        genesysCloudButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genesysCloudButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        genesysCloudButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        genesysCloudButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        genericButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genericButton.bottomAnchor.constraint(equalTo: genesysCloudButton.topAnchor, constant: -100).isActive = true
        genericButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        genericButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        genesysEngageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genesysEngageButton.topAnchor.constraint(equalTo: genesysCloudButton.bottomAnchor, constant: 100).isActive = true
        genesysEngageButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        genesysEngageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        copyrightText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        copyrightText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        copyrightText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        
        appCurrentVersionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        appCurrentVersionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        appCurrentVersionLabel.centerYAnchor.constraint(equalTo: copyrightText.centerYAnchor).isActive = true
        
        
        sdkCurrentVersionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        sdkCurrentVersionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sdkCurrentVersionLabel.bottomAnchor.constraint(equalTo: appCurrentVersionLabel.topAnchor).isActive = true
        
        
    }
    
    
    
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    

    
}
