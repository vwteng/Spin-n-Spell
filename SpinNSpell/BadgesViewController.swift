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
    
    //var selectedBadge = NSDictionary()
    let cellTableIdentifier = "CellTableIdentifier"
    @IBOutlet weak var tableView: UITableView!
    var delegate : BadgesViewControllerDelegate?
    
    var badges = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(BadgeCell.self, forCellReuseIdentifier : cellTableIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.delegate?.updateData(self.badges)
        print("\(badges)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as! BadgeCell
        selectedBadge = badges[indexPath!.row]
        self.delegate?.updateBadges(selectedBadge)
    }*/
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return badges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! BadgeCell
        let imageView = UIImageView(frame: CGRectMake(50, 10, 5, 5))
        let rowData = badges[indexPath.row]
        // Code for loading an image from the web
        let url = NSURL(string: (rowData!["badgeImage"] as? String)!)
        let data = NSData(contentsOfURL: url!)
        imageView.image = UIImage(data: data!)
        // End loading image code
        cell.imageView?.image = imageView.image
        cell.badge = (rowData!["badge"]! as? String)!
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

}
