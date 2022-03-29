//
//  SetupOrgParamsEngageView.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit
import SmartVideoSDK


class ChatView: UIView {
    
    let chatTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isUserInteractionEnabled = true
        tv.register(LeftMessageImageChatTableViewCell.self, forCellReuseIdentifier: "otherChatCell")
        tv.register(ChatTableViewCell.self, forCellReuseIdentifier: "myChatCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.estimatedRowHeight = 60
        tv.rowHeight = UITableView.automaticDimension
//        tv.dataSource = self
        return tv
    }()
    
    let chatTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(red: 242/255, green: 245/255, blue: 247/255, alpha: 1)
        return view
    }()
    
    let chatTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .AppBackgroundColor
        tf.backgroundColor = .clear
        return tf
        
    }()
    
    let chatSendButton: UIButton = {
        let sb = UIButton()
        sb.translatesAutoresizingMaskIntoConstraints = false
//        sb.setImage(UIImage(systemName: "arrow.forward.circle.fill"), for: .normal)
        sb.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sb.tintColor = .systemBlue
        sb.imageView?.contentMode = .scaleAspectFit
        sb.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return sb
        
    }()
    
    let headerView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        return v
    }()
    
    let headerTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    let closeChatButton: UIButton = {
        let sb = UIButton()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.tintColor = .white
        return sb
    }()
    
    var messages: [ChatMessage] = []
    var memberID = String()
    var displayName = String()
    var avatarImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

}

extension ChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(message.date) {
            formatter.dateFormat = "HH:mm"
        }
        else {
            formatter.dateFormat = "dd:MM HH:mm"
        }
        

        if message.sender == memberID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherChatCell", for: indexPath) as! LeftMessageImageChatTableViewCell
            cell.messageLabel.text = message.message
            cell.dateLabel.text = formatter.string(from: message.date)
            if let image = avatarImage {
                cell.profileImageView.image = image
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChatCell", for: indexPath) as! ChatTableViewCell
            cell.messageLabel.text = message.message
            cell.dateLabel.text = formatter.string(from: message.date)
            return cell
        }
    }
    
    
    
    fileprivate func setupViews() {
        
        self.addSubview(chatTableView)
        self.addSubview(chatTextView)
        self.chatTextView.addSubview(chatTextField)
        self.chatTextView.addSubview(chatSendButton)
        self.addSubview(headerView)
        self.headerView.addSubview(headerTitle)
        self.headerView.addSubview(closeChatButton)
        
        self.chatSendButton.trailingAnchor.constraint(equalTo: chatTextView.trailingAnchor, constant: -10).isActive = true
        self.chatSendButton.bottomAnchor.constraint(equalTo: chatTextView.bottomAnchor, constant: -10).isActive = true
        self.chatSendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.chatSendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.chatTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.chatTextField.leadingAnchor.constraint(equalTo: chatTextView.leadingAnchor, constant: 20).isActive = true
        self.chatTextField.trailingAnchor.constraint(equalTo: chatSendButton.leadingAnchor, constant: 20).isActive = true
        self.chatTextField.bottomAnchor.constraint(equalTo: chatTextView.bottomAnchor, constant: -10).isActive = true
        self.chatTextField.topAnchor.constraint(equalTo: chatTextView.topAnchor, constant: 10).isActive = true
        
        self.chatTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.chatTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.chatTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        self.chatTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        self.chatTableView.bottomAnchor.constraint(equalTo: chatTextView.topAnchor).isActive = true
        self.chatTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.chatTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.closeChatButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.closeChatButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        self.closeChatButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        self.closeChatButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50).isActive = true
        
        self.headerTitle.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
        self.headerTitle.centerYAnchor.constraint(equalTo: self.closeChatButton.centerYAnchor).isActive = true
        
        self.headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.chatTableView.dataSource = self
        
        
    }
    
    
}

class ChatTableViewCell: UITableViewCell {
    let messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    let messageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .lightGray
        l.numberOfLines = 1
        l.textAlignment = .right
        return l
    }()
    
    let stack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 5
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.setupView()
    }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.contentView.addSubview(messageView)
        self.messageView.addSubview(stack)
        self.stack.addArrangedSubview(messageLabel)
        self.stack.addArrangedSubview(dateLabel)
        
        self.stack.leadingAnchor.constraint(equalTo: self.messageView.leadingAnchor, constant: 10).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.messageView.trailingAnchor, constant: -10).isActive = true
        self.stack.topAnchor.constraint(equalTo: self.messageView.topAnchor, constant: 10).isActive = true
        self.stack.bottomAnchor.constraint(equalTo: self.messageView.bottomAnchor, constant: -10).isActive = true
        
        self.messageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100).isActive = true
        self.messageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        self.messageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        
        self.messageView.backgroundColor = .systemBlue
    }
}

class LeftMessageImageChatTableViewCell: ChatTableViewCell {
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        img.tintColor = .lightGray
        img.image = UIImage(systemName: "person.circle.fill")
        return img
     }()
    
    override func setupView() {
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(messageView)
        self.stack.addArrangedSubview(messageLabel)
        self.stack.addArrangedSubview(dateLabel)
        self.messageView.addSubview(stack)
        
        self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.messageView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 5).isActive = true
        self.messageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50).isActive = true
        self.messageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        
        self.stack.leadingAnchor.constraint(equalTo: self.messageView.leadingAnchor, constant: 10).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.messageView.trailingAnchor, constant: -10).isActive = true
        self.stack.topAnchor.constraint(equalTo: self.messageView.topAnchor, constant: 10).isActive = true
        self.stack.bottomAnchor.constraint(equalTo: self.messageView.bottomAnchor, constant: -10).isActive = true
    }
}
