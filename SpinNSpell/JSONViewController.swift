//
//  JSONViewController.swift
//  SpinNSpell
//
//  Created by Conrad Zimney on 12/2/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class JSONViewController: UIViewController {
    
    var topics : [NSDictionary] = [NSDictionary]()

    @IBOutlet weak var textBox: UITextField!
    
    @IBAction func checkForNewTopics(sender: AnyObject) {
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
            } catch {
                print("\(error)")
            }
        }
        task.resume()
        print("\(topics)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textBox.text = "https://students.washington.edu/conrad16/ios/spelling-json-files/Animals.json"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
