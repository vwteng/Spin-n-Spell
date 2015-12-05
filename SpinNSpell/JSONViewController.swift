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
            print("URL Task Worked: \(statusCode)")
            do {
                self.topics = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [NSDictionary]
                self.delegate?.updateData(self.topics)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
        print("\(topics)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textBox.text = "https://students.washington.edu/conrad16/ios/spelling-json-files/Animals.json"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("\(topics)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ChangeTopicViewController {
            // will need to pass settings around?
            // Might not even need to pass data here since it is handled through the extensions and protocols
        }
    }
    
}
