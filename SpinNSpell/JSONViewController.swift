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
    
    @IBAction func checkForNewTopics(sender: AnyObject) {
        //print("\(topics)")
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: self.textBox.text!)
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let statusCode = (response as! NSHTTPURLResponse).statusCode
            print("URL Task Status: \(statusCode)")
            do {
                self.topics = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [NSDictionary]
                self.delegate?.updateData(self.topics)
                self.presentViewController(self.showAlert("Success", alertMsg: "Successfully downloaded new topics", alertDismiss: "OK"),animated: true,completion: nil)
            } catch {
                print("\(error)")
                self.presentViewController(self.showAlert("Error", alertMsg: "Please try a different URL", alertDismiss: "Dismiss"),animated: true,completion: nil)
            }
        }
        task.resume()
        print("\(topics)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textBox.text = "https://students.washington.edu/conrad16/ios/spelling-json-files/Animals.json"
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
    }
    
    // Display an alert
    func showAlert(alertTitle: String, alertMsg: String, alertDismiss: String) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: alertDismiss, style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in NSLog("Dismissed")
        }))
        return alert
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("\(topics)")
    }
    
    func GoToInfoSegue() {
        self.performSegueWithIdentifier("GoToInfo", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ChangeTopicViewController {
            // will need to pass settings around?
            // Might not even need to pass data here since it is handled through the extensions and protocols
        }
    }
    
}
