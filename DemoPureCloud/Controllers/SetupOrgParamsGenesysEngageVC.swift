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
    

    let notification: UILabel = {
        let anl = UILabel()
        anl.translatesAutoresizingMaskIntoConstraints = false
        anl.font? = UIFont.boldSystemFont(ofSize: 22)
        anl.backgroundColor? = UIColor.clear
        anl.textColor = UIColor.black
        anl.text = "This functionality is still in development. Pls contact our support team at support@videoengager.com to get information about release date."
        anl.numberOfLines = 0
        anl.textAlignment = .center
        anl.sizeToFit()
        return anl
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        setupViews()
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .AppBackgroundColor

    }
    
        
    deinit {
        print("OS reclaimed memory allocated for SetupOrgParamsGenesysEngageVC.")
    }
    
    
    fileprivate func setupViews() {
        view.addSubview(notification)
        
        notification.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notification.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        notification.widthAnchor.constraint(equalToConstant: 250).isActive = true

    }
    
    
    
    override open var shouldAutorotate: Bool {
        return false
    }
    

}






