//
//  StatsViewController.swift
//  Neighborhood Quest
//
//  Created by Kyle Kimery on 11/28/16.
//  Copyright © 2016 Kenneth James. All rights reserved.
//

import UIKit
import CoreData
import Social

class StatsViewController: UIViewController {

    @IBOutlet weak var avgTimeLabel: UILabel!
    @IBOutlet weak var expBarButton: ExpButtonView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var totalQuizzesLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    var statsArray = [NSManagedObject]()
    
    func fetchData() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Stats")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            statsArray = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func showShareOptions(sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: "", message: "Share your Note", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                twitterComposeVC.setInitialText("Wow, I'm level \(self.levelLabel.text!) on Neighborhood Quest with an accurancy of \(self.accuracyLabel.text!). Can y'all beat that?")
                
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account.")
            }
            
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        
        
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(dismissAction)
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expBarButton.type = "stats"
        fetchData()
        let level = statsArray[0].valueForKey("level") as! String
        let exp = Int(statsArray[0].valueForKey("experience") as! String)
        let expRequired = 50 * Int(level)!
        let quizzes = Int(statsArray[0].valueForKey("numQuizzes") as! String)
        let numCorrect = Int(statsArray[0].valueForKey("numCorrect") as! String)
        levelLabel.text = level
        experienceLabel.text = String(exp!) + "/" + String(expRequired)
        totalQuizzesLabel.text = String(quizzes!)
        correctLabel.text = String(numCorrect!)
        avgTimeLabel.text = String(round(1000*Double(statsArray[0].valueForKey("averageTime") as! String)!)/1000)
        
        
        
        
        
        
        let percent = Double(numCorrect!)/Double(quizzes!)
        accuracyLabel.text = String(round(100*percent*100)/100) + "%"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
