//
//  ChangeTopicViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/3/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

protocol ChangeTopicViewControllerDelegate {
    func updateData(data: [NSDictionary])
    func updateCurrentTopic(topic: NSDictionary)
}

class ChangeTopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedTopic = NSDictionary()
    let cellTableIdentifier = "CellTableIdentifier"
    @IBOutlet weak var tableView: UITableView!
    var delegate : ChangeTopicViewControllerDelegate?
    
    var topics = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TopicCell.self, forCellReuseIdentifier : cellTableIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.delegate?.updateData(self.topics)
        print("\(topics)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Table View Functions //
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as! TopicCell
        selectedTopic = topics[indexPath!.row]
        self.delegate?.updateCurrentTopic(selectedTopic)
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! TopicCell
        let imageView = UIImageView(frame: CGRectMake(50, 10, 5, 5))
        let rowData = topics[indexPath.row]
        // Code for loading an image from the web
        let url = NSURL(string: (rowData["startingImage"] as? String)!)
        let data = NSData(contentsOfURL: url!)
        imageView.image = UIImage(data: data!)
        // End loading image code
        cell.imageView?.image = imageView.image
        cell.topic = (rowData["topic"]! as? String)!
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}
