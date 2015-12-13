//
//  ViewController.swift
//  SpinNSpell
//
//  Created by Vivian on 11/30/15.
//  Copyright © 2015 Vivian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logo: UIImageView!
    
    // Initialize the loaded topics to be Animals.json
    var topics : [NSDictionary] = [
        [
            "topic": "Farm Animals",
            "startingImage": "http://donate.worldvision.org/media/catalog/product/cache/1/image/310x/9df78eab33525d08d6e5fb8d27136e95/D/4/D4041711_13_Farm_Animals.jpg",
            "words": [
                "Cow": "http://media-2.web.britannica.com/eb-media/11/136111-004-C620AA83.jpg",
                "Pig": "http://dealbreaker.com/uploads/2013/06/pig1_1204022c.jpg",
                "Chicken": "https://timenewsfeed.files.wordpress.com/2013/03/chicken.jpg?w=753",
                "Horse": "http://buzzsharer.com/wp-content/uploads/2015/06/beautiful-running-horse.jpg",
                "Sheep": "https://upload.wikimedia.org/wikipedia/commons/c/c4/Lleyn_sheep.jpg",
                "Rabbit": "http://media.philly.com/images/071514-rabbit-istock-600.jpg"
            ]
        ],
        [
            "topic": "House Animals",
            "startingImage": "http://pubpages.unh.edu/~zmq7/petsss!.jpg",
            "words": [
                "Cat": "http://www.sucatpartners.org/wp-content/uploads/2012/08/cat_in_grass.jpg",
                "Dog": "http://animalia-life.com/data_images/dog/dog1.jpg",
                "Bird": "http://thepetwiki.com/images/thumb/Parakeet.jpg/400px-Parakeet.jpg",
                "Fish": "http://cf.ltkcdn.net/small-pets/images/slide/130952-847x567r1-Ordinary-goldfish.jpg",
                "Lizard": "http://rivista-cdn.reptilesmagazine.com/collared-lizard3.jpg?ver=1406063859",
                "Hamster": "http://vignette3.wikia.nocookie.net/animalcrossing/images/4/49/Tumblr_lvrcmvCpsS1qbeyouo1_500.jpg/revision/latest?cb=20130325185045"
            ]
        ],
        [
            "topic": "Bugs",
            "startingImage": "http://www.upstartbayarea.org/storage/bugs.jpg",
            "words": [
                "Fly": "http://suterra.com/wp-content/uploads/2012/07/Bluebotte-fly.jpg",
                "Spider": "https://upload.wikimedia.org/wikipedia/commons/9/9b/Kaldari_Salticus_scenicus_female_01.jpg",
                "Firefly": "http://s3.amazonaws.com/assets.prod.vetstreet.com/47/73/61ee5aba4d9eaa7ca1b3534a4f39/Glowing-firefly-Alamy-A8TC0A-335lc061113.jpg",
                "Bee": "https://upload.wikimedia.org/wikipedia/commons/b/b5/Honey_bee_(Apis_mellifera).jpg",
                "Wasp": "http://m.bonide.com/photos/Hornet_large.jpg",
                "Beetle": "http://freepages.misc.rootsweb.ancestry.com/~larsonmorgan/beetles/beetle%20-%20Japanese%20Beetle%20(Popillia%20japonica)%20[MO%2006].jpg",
                "Ant": "http://www.spirit-animals.com/wp-content/uploads/2013/03/Ant-3.jpg",
                "Pillbug": "https://northshorebiology101.files.wordpress.com/2012/06/pill_bug.jpg"
            ]
        ],
        [
            "topic": "Reptiles",
            "startingImage": "https://upload.wikimedia.org/wikipedia/commons/2/2c/Extant_reptilia.jpg",
            "words": [
                "Iguana": "http://www.xromm.org/files/images/projects/iguana-breathing/Figure1-GreenIguana-2.jpg",
                "Turtle": "http://assets.worldwildlife.org/photos/167/images/original/MID_225023-circle-hawksbill-turtle.jpg?1345565600",
                "Snake": "https://doowansnewsandevents.files.wordpress.com/2013/10/snake-medicine.jpg"
            ]
        ]
    ]
    
    var maxLength = 8
    var sound = true
    
    var initialBadge : String = ""
    
    // Default Topic to Farm Animals: 
    // For some reason setting currentTopic to topics[0] doesn't compile...
    
    var currentTopic : NSDictionary = [
        "topic": "Farm Animals",
        "startingImage": "http://donate.worldvision.org/media/catalog/product/cache/1/image/310x/9df78eab33525d08d6e5fb8d27136e95/D/4/D4041711_13_Farm_Animals.jpg",
        "words": [
            "Cow": "http://media-2.web.britannica.com/eb-media/11/136111-004-C620AA83.jpg",
            "Pig": "http://dealbreaker.com/uploads/2013/06/pig1_1204022c.jpg",
            "Chicken": "https://timenewsfeed.files.wordpress.com/2013/03/chicken.jpg?w=753",
            "Horse": "http://buzzsharer.com/wp-content/uploads/2015/06/beautiful-running-horse.jpg",
            "Sheep": "https://upload.wikimedia.org/wikipedia/commons/c/c4/Lleyn_sheep.jpg",
            "Rabbit": "http://media.philly.com/images/071514-rabbit-istock-600.jpg"
        ]
    ]

    @IBOutlet weak var currentTopicLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        currentTopicLabel.text = "Current Topic: \(currentTopic["topic"]!)"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTopicLabel.text = "Current Topic: \(currentTopic["topic"]!)"
        
        navigationController!.setNavigationBarHidden(false, animated:true)
        let infoButton:UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.addTarget(self, action: "GoToInfoSegue", forControlEvents: UIControlEvents.TouchUpInside)
        infoButton.setTitle("Help", forState: UIControlState.Normal)
        infoButton.sizeToFit()
        infoButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.9), forState: UIControlState.Normal)
        let myCustomInfoButtonItem:UIBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = myCustomInfoButtonItem
        self.navigationItem.setHidesBackButton(true, animated: false)
                
        logo.image = UIImage(named: "logo")
    }
    
    func GoToInfoSegue() {
        self.performSegueWithIdentifier("GoToInfo", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func playPushed(sender: AnyObject) {
        activityIndicator.startAnimating()
    }
    
    @IBAction func changeTopic(sender: AnyObject) {
        activityIndicator.startAnimating()
    }
    @IBAction func badgesPushed(sender: AnyObject) {
        activityIndicator.startAnimating()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()

        if segue.identifier == "GoToSettingsSegue" {
            if let vc = segue.destinationViewController as? SettingsViewController {
                (segue.destinationViewController as! SettingsViewController).delegate = self
                vc.topics = self.topics
                vc.maxLength = self.maxLength
                vc.sound = self.sound
            }
        }
        if segue.identifier == "GoToPlaySegue" {
            if let vc = segue.destinationViewController as? PlayViewController {
                vc.topic = self.currentTopic
                vc.maxLength = self.maxLength
                vc.sound = self.sound
            }
        }
        if segue.identifier == "GoToChangeSegue" {
            if let vc = segue.destinationViewController as? ChangeTopicViewController {
                (segue.destinationViewController as! ChangeTopicViewController).delegate = self
                vc.topics = self.topics
            }
        }
    }
}

extension ViewController: SettingsViewControllerDelegate, ChangeTopicViewControllerDelegate {
    func updateData(data: [NSDictionary]) {
        self.topics = data
    }
    func updateCurrentTopic(topic: NSDictionary) {
        self.currentTopic = topic
    }
    func updateSettings(sound: Bool, maxLength: Int) {
        self.sound = sound
        self.maxLength = maxLength
    }
}
