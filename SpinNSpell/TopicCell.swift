//
//  TopicCell.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/3/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {
    
    var topic: String = "" {
        didSet {
            if (topic != oldValue) {
                topicLabel.text = topic
            }
        }
    }
    
    var topicLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let topicLabelRect = CGRectMake(50, 5, 70, 15)
        let topicMarker = UILabel(frame: topicLabelRect)
        topicMarker.textAlignment = NSTextAlignment.Right
        topicMarker.text = "Topic:"
        topicMarker.font = UIFont.boldSystemFontOfSize(12)
        contentView.addSubview(topicMarker)
        
        let topicValueRect = CGRectMake(130, 5, 200, 15)
        topicLabel = UILabel(frame: topicValueRect)
        contentView.addSubview(topicLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}