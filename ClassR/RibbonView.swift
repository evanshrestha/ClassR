//
//  RibbonView.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/26/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

@IBDesignable
class RibbonView: UIView {
    
    var color = UIColor.red
    var isRibbon = true
    
    override func draw(_ rect: CGRect) {
        if isRibbon {
            let path = UIBezierPath()
            path.lineWidth = CGFloat(1)
            path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
            path.addLine(to: CGPoint(x: CGFloat(0), y: CGFloat(bounds.height)))
            path.addLine(to: CGPoint(x: CGFloat(bounds.width/2), y:CGFloat(bounds.height * 2/3)))
            path.addLine(to: CGPoint(x: CGFloat(bounds.width), y:CGFloat(bounds.height)))
            path.addLine(to: CGPoint(x: CGFloat(bounds.width), y:CGFloat(0)))
            path.close()
            color.setFill()
            path.fill()
        } else {
            let path = UIBezierPath(ovalIn: bounds.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)))
            color.setFill()
            path.fill()
        }
    }
    
    
}
