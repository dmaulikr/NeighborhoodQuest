//
//  PushButtonView.swift
//  Neighborhood Quest
//
//  Created by Kyle Kimery on 11/21/16.
//  Copyright © 2016 Kenneth James. All rights reserved.
//

import UIKit

class PushButtonView: UIButton {

    var colorInt = 0
    
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        
        if colorInt == 0{
            UIColor.blueColor().setFill()
        }else if colorInt == 1{
            UIColor.redColor().setFill()
        }else {
            UIColor.greenColor().setFill()
        }
        
        path.fill()
    }

}
