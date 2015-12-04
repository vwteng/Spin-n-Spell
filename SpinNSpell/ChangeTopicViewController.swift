//
//  ChangeTopicViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/3/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class ChangeTopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedTopic = ""
    let cellTableIdentifier = "CellTableIdentifier"
    @IBOutlet weak var tableView: UITableView!
    
    let topics = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tableView.registerClass(TopicCell.self, forCellReuseIdentifier: cellTableIdentifier)
        tableView.registerClass(TopicCell.self, forCellReuseIdentifier : cellTableIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table View Functions //
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as! TopicCell
        selectedTopic = currentCell.topic
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! TopicCell
        let imageView = UIImageView(frame: CGRectMake(10, 10, 5, 5))
        //let image = UIImage(named: "<DYNAMICALLY LOAD STARTED IMAGE HERE>")
        //imageView.image = image
        //cell.imageView?.image = image
        
        let rowData = topics[indexPath.row]
        cell.topic = rowData["topic"]! as! String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
}
