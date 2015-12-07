//
//  BadgeCell.swift
//  SpinNSpell
//
//  Created by iGuest on 12/6/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class BadgeCell: UITableViewCell {
   
    var badge: String = "" {
        didSet {
            if (badge != oldValue) {
                badgeType.text = badge
            }
        }
    }
    
    var badgeType: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let badgeTypeRect = CGRectMake(130, 10, 200, 30)
        badgeType = UILabel(frame: badgeTypeRect)
        contentView.addSubview(badgeType)
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
