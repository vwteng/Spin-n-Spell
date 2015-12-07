//
//  BadgesViewController.swift
//  SpinNSpell
//
//  Created by iGuest on 12/6/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

protocol BadgesViewControllerDelegate {
    func updateData(data: [NSDictionary])
    func updateBadges(badge: NSDictionary)
}

class BadgesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var badges = [NSDictionary]()
    let cellTableIdentifier = "CellTableIdentifier"
    var delegate : BadgesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(BadgeCell.self, forCellReuseIdentifier : cellTableIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
