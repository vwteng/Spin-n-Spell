//
//  JSONViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/2/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

protocol JSONViewControllerDelegate {
    func updateData(data: [NSDictionary])
}

class JSONViewController: UIViewController {
    
    var topics : [NSDictionary] = [NSDictionary]()
    
    var delegate : JSONViewControllerDelegate?
    
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func checkForNewTopics(sender: AnyObject) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: self.textBox.text!)
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                self.topics = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [NSDictionary]
                self.delegate?.updateData(self.topics)
                dispatch_async(dispatch_get_main_queue(), {
                    self.statusLabel.text = "Download Status: Success!"
                })
            } catch {
                print("\(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.statusLabel.text = "Download Status: Failure"
                })
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textBox.text = "https://students.washington.edu/conrad16/ios/spelling-json-files/Animals.json"
        checkButton.layer.cornerRadius = 5
        checkButton.layer.borderWidth = 1
        checkButton.layer.borderColor = UIColor.blackColor().CGColor
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("\(topics)")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func GoToInfoSegue() {
        self.performSegueWithIdentifier("GoToInfo", sender: nil)
    }

}
