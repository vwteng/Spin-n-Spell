//
//  BadgesViewController.swift
//  SpinNSpell
//
//  Created by iGuest on 12/6/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

var badges = [String]()
var badgeIndexCount: Int = 0

protocol BadgesViewControllerDelegate {
    func updateData(data: [NSDictionary])
    func updateBadges(badge: String)
}

class BadgesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var topics = [NSDictionary]()
    var currentTopic = NSDictionary()
    
    var maxLength = Int()
    var sound = Bool()
    
    let cellTableIdentifier = "CellTableIdentifier"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    var delegate : BadgesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        badges.insert("", atIndex: badgeIndexCount)
        tableView.registerClass(BadgeCell.self, forCellReuseIdentifier : cellTableIdentifier)
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        self.delegate?.updateData(self.topics)
        print("\(badges)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func GoToInfoSegue() {
        self.performSegueWithIdentifier("GoToInfo", sender: nil)
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return badges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! BadgeCell
        cell.textLabel?.text = badges[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        /*
        let image : UIImage = UIImage(named: "star")!
        cell.imageView!.image = image*/
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

}