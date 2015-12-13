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
    
    var imageDict : [String : UIImage] = [String : UIImage]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TopicCell.self, forCellReuseIdentifier : cellTableIdentifier)
        
        tableView.delegate = self
        activityIndicator.startAnimating()
        
        for topic in topics {
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            /* Create session, and optionally set a NSURLSessionDelegate. */
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            let URL = NSURL(string: topic["startingImage"] as! String)
            let request = NSMutableURLRequest(URL: URL!)
            request.HTTPMethod = "GET"
            
            /* Start a new Task */
            let task = session.dataTaskWithRequest(request, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
                if (error == nil) { // Success
                    let statusCode = (response as! NSHTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let image = UIImage(data: data!)
                        self.imageDict[topic["topic"]! as! String] = image
                        if self.imageDict.count == self.topics.count {
                            self.activityIndicator.hidesWhenStopped = true
                            self.activityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    })
                }
                else { // Failure
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            })
            task.resume()
        }
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
    }
    
    func GoToInfoSegue() {
        self.performSegueWithIdentifier("GoToInfo", sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.delegate?.updateData(self.topics)
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
        if !activityIndicator.isAnimating() {
            imageView.image = imageDict[rowData["topic"] as! String]
        }
        cell.backgroundColor = UIColor.clearColor()
        
        cell.imageView?.image = imageView.image
        cell.topic = (rowData["topic"]! as? String)!
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}
