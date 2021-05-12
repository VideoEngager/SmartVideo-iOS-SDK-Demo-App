//
//  NotificationInternetConnection.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit

class NotificationInternetConnection: UIView {
     
    let bgView: UIView = {
        let nv = UIView()
        nv.translatesAutoresizingMaskIntoConstraints = false
        nv.backgroundColor = UIColor.red
        return nv
    }()

    
    let notificationTitle: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor? = UIColor.clear
        nl.textColor = UIColor.white
        nl.text = "No internet connectivity"
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.numberOfLines = 0
        nl.textAlignment = .center
        nl.sizeToFit()
        return nl
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupViews()
        
        
    }
    
    
    
    fileprivate func setupViews() {
        self.addSubview(bgView)
        self.addSubview(notificationTitle)

        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        notificationTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        notificationTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        notificationTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
