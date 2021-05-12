//
//  SetupOrgParamsView.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import Foundation
import UIKit
import SmartVideo


class SetupOrgParamsView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let ENTRY_CELL_HEIGHT: CGFloat = 70
    let NUM_ROWS: Int = 7
    
//    var placeholderArray = ["Customer Name","Organization Id","Deployment Id", "VideoEngager URL", "Tenant Id", "Environment", "Genesys PureCloud Queue"]
    var placeholderArray = [String]()
    let iconNameArray = ["url", "url", "url", "url", "url", "url", "url"]
    var initParams = Array<Any>()
    
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    lazy var tableView: UITableView = {
        let mt = UITableView()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.backgroundColor = UIColor.AppBackgroundColor
        mt.delegate = self
        mt.dataSource = self
        mt.separatorStyle = .none
        mt.rowHeight = ENTRY_CELL_HEIGHT
        mt.alwaysBounceVertical = false
        return mt
    }()
    
    
    let cellId = "cellId"
    
    
     
    let click2VideoButton: UIButton = {
        let lb = UIButton()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.layer.cornerRadius = 10
        lb.layer.borderColor = UIColor.gray.cgColor
        lb.backgroundColor = UIColor.gray
        lb.setTitle("Start Video", for: UIControl.State.normal)
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
        lb.setTitle("Start Audio", for: UIControl.State.normal)
        lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        lb.setTitleColor(UIColor.white, for: UIControl.State.normal)
        lb.isEnabled = false
        return lb
    }()
    
    private var customer_name = "Mobile Tester"
    private var org_id = ""
    private var dep_id = ""
    private var smart_video_url = ""
    private var tenant_id = ""
    private var host_url = ""
    private var genesys_host_url = ""
    private var genesys_queue = ""
    var environment: Environment = .live
    
    var GENESYS_CLOUD_INIT_PARAMS_LIVE = [String]()
    var GENESYS_CLOUD_INIT_PARAMS_STAGING = [String]()
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupViews()
        
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "SmartVideo-Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        else {
            debug("SmartVideo-Info.plist not exist in the project. Please add it to the project.", level: .error, type: .genesys)
            return
        }

        guard let array = nsDictionary?["items"] as? [[String: Any]] else {
            return
        }
        

        for item in array {
            if let config = try? GenesysConfigurations(dictionary: item) {
                org_id = config.organizationID
                dep_id = config.deploymentID
                smart_video_url = config.engineUrl
                genesys_host_url = config.environmentURL
                genesys_queue = config.queue
                environment = config.environment
                if let agentsArray = item["agents"] as? [[String: String]] {
                    for agentData in agentsArray {
                        if let tennantId = agentData["Tenant ID"]
                        {
                            tenant_id = tennantId
                        }
                    }
                }
                if environment == .live {
                    GENESYS_CLOUD_INIT_PARAMS_LIVE = [customer_name, org_id, dep_id, smart_video_url, tenant_id, genesys_host_url, genesys_queue]
                } else if environment == .staging {
                    GENESYS_CLOUD_INIT_PARAMS_STAGING = [customer_name, org_id, dep_id, smart_video_url, tenant_id, genesys_host_url, genesys_queue]
                }
            }
        }
        
        initParams = GENESYS_CLOUD_INIT_PARAMS_STAGING
        environment = .staging
        
        
        placeholderArray = [
            "customer_name".l10n(),
            "org_id".l10n(),
            "deployment_id".l10n(),
            "ve_url".l10n(),
            "tenant_id".l10n(),
            "env".l10n(),
            "genesys_cloud_queue".l10n()
        ]
        
        
        self.tableView.register(ParamsCell.self, forCellReuseIdentifier: cellId)

        
        
    }
    
    
    
    fileprivate func setupViews() {
        
        addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 50 + (ENTRY_CELL_HEIGHT * CGFloat(NUM_ROWS)) + 50 + 50 + 50 + 50 + 50
        scrollView.contentSize = CGSize(width: width, height: height)

        scrollView.addSubview(tableView)
        scrollView.addSubview(click2VoiceButton)
        scrollView.addSubview(click2VideoButton)
        
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        tableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: ENTRY_CELL_HEIGHT * CGFloat(NUM_ROWS)).isActive = true
        
        click2VoiceButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50).isActive = true
        click2VoiceButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        click2VoiceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        click2VoiceButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        click2VideoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        click2VideoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        click2VideoButton.topAnchor.constraint(equalTo: click2VoiceButton.bottomAnchor, constant: 50).isActive = true
        click2VideoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUM_ROWS
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ParamsCell {
            let item = indexPath.item
            cell.textField.placeholder = placeholderArray[item]
            if initParams.count == 7 {
                if let txt = initParams[item] as? String {
                    cell.textField.text = txt
                }
            } else {
                fatalError("Incorrect SmartVideo-Info.plist")
            }
            cell.textField.delegate = self
            let iconName = iconNameArray[item]

            cell.passImageView.image = UIImage(named: iconName)!.withRenderingMode(.alwaysTemplate)
            cell.selectionStyle = .none
            if item != 0 {
                cell.textField.isUserInteractionEnabled = false
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ParamsCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}






class ParamsCell: UITableViewCell {
    
    var userId: String?
    var isUserHCP: Bool?
    
    let UITEXT_FIELD_HEIGTH: CGFloat = 44
    
    let textField: UITextField = {
        let pf = UITextField()
        pf.translatesAutoresizingMaskIntoConstraints = false
        pf.layer.cornerRadius = CGFloat(10)
        pf.clipsToBounds = true
        pf.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        pf.layer.borderColor = UIColor.AppBackgroundColor.cgColor
        pf.layer.borderWidth = 1
        pf.tintColor = UIColor.AppBackgroundColor
        pf.textAlignment = .center
        pf.backgroundColor = UIColor.clear
        pf.font = UIFont.systemFont(ofSize: 14)
        pf.keyboardType = .default
        pf.keyboardAppearance = .default
        pf.isSecureTextEntry = false
        pf.autocorrectionType = .no
        pf.leftViewMode = .always
        return pf
    }()
        
        
        
        
    let passImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 15, y: 0, width: 16, height: 21))
        iv.tintColor = UIColor.lightGray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    
    
    let passUiView: UIView = {
        let uiv = UIView(frame: CGRect(x: 0 , y: 0, width: 16 + 15 + 15, height: 21))
        return uiv
    }()
    
    
    let dividerLine: UIView = {
        let dl = UIView()
        dl.translatesAutoresizingMaskIntoConstraints = false
        dl.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return dl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        
    }
    

    
    
    fileprivate func setupViews() {
        passUiView.addSubview(passImageView)
        textField.leftView = passUiView
        addSubview(textField)
        
        
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: UITEXT_FIELD_HEIGTH).isActive = true
        
        
    }
    
 
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
}

