//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Keerthi Shekar G on 15/03/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    var doneImage = UIImageView()
    var taskNameLabel = UILabel()
    var taskDescriptionLabel = UILabel()
    var createdAtLabel = UILabel()
    let padding: CGFloat = 5
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        
        doneImage = UIImageView(frame: CGRect.zero)
        contentView.addSubview(doneImage)
        
        taskNameLabel = UILabel(frame: CGRect.zero)
        taskNameLabel.textAlignment = .left
        taskNameLabel.textColor = UIColor.black
        contentView.addSubview(taskNameLabel)
        
        taskDescriptionLabel = UILabel(frame: CGRect.zero)
        taskDescriptionLabel.textAlignment = .center
        taskDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        taskDescriptionLabel.textColor = UIColor.black
        contentView.addSubview(taskDescriptionLabel)
        
        createdAtLabel = UILabel(frame: CGRect.zero)
        createdAtLabel.font = UIFont.systemFont(ofSize: 12)
        createdAtLabel.textAlignment = .right
        createdAtLabel.textColor = UIColor.black
        contentView.addSubview(createdAtLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskNameLabel.frame = CGRect(x:padding, y:padding, width:40, height:frame.height/2)
        taskNameLabel.sizeToFit()
        taskDescriptionLabel.frame = CGRect(x:padding, y:frame.height/2 + padding, width:100, height:frame.height/2)
        taskDescriptionLabel.sizeToFit()
        createdAtLabel.frame = CGRect(x:frame.width - 100, y:padding, width:100, height:frame.height/2)
        createdAtLabel.sizeToFit()
        doneImage.frame = CGRect(x:frame.width - 25 - padding, y:frame.height/2 , width:25, height:25)
    }
}

