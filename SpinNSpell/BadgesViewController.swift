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
    func updateBadges(badge: String)
}

class BadgesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var selectedBadge = NSDictionary()
    let cellTableIdentifier = "CellTableIdentifier"
    @IBOutlet weak var tableView: UITableView!
    var delegate : BadgesViewControllerDelegate?
    
    var badges = ["Created a new game",
                  "5 correct words in a row",
                  "10 correct words in a row",
                  "10 correct words in a game",
                  "20 correct words in a game",
                  "Guessed all words in a topic",
                  "Guessed all words in all topics"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(BadgeCell.self, forCellReuseIdentifier : cellTableIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.delegate?.updateData(self.badges)
        //print("\(badges)")
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as! BadgeCell
        selectedBadge = badges[indexPath!.row]
        self.delegate?.updateBadges(selectedBadge)
    } */
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return badges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! BadgeCell
        cell.textLabel?.text = badges[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

}
