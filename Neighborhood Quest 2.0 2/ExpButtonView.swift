//
//  ExpButtonView.swift
//  Neighborhood Quest
//
//  Created by Kyle Kimery on 11/28/16.
//  Copyright © 2016 Kenneth James. All rights reserved.
//

import UIKit
import CoreData


class ExpButtonView: UIButton {

    var statsArray = [NSManagedObject]()
    
    var length = 0.0
    var timeGone = 0.0
    var type = "timer"

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        if type == "timer"{
            UIColor.redColor().setFill()
        }else{
            UIColor.blueColor().setFill()
        }
        path.fill()
        
        let newPath = UIBezierPath()
        newPath.lineWidth = 30.0
        newPath.moveToPoint(CGPoint(x: 0, y: 15))
        
        if type == "stats"{
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
        
        
            let expRequired = 50 * Int(statsArray[0].valueForKey("level") as! String)!
            let exp = Int(statsArray[0].valueForKey("experience") as! String)!
            _ = Int(statsArray[0].valueForKey("numQuizzes") as! String)
            _ = Int(statsArray[0].valueForKey("numCorrect") as! String)
        
            let percent = Double(exp)/Double(expRequired)
            
            length = percent
        }else{
            length = timeGone / 30.0
        }
        
        
        newPath.addLineToPoint(CGPoint(x: length*400, y: 15))
        
        if type == "stats"{
            UIColor.cyanColor().setStroke()
        }else{
            UIColor.greenColor().setStroke()
        }
        
        newPath.stroke()
        
        
    }

}
