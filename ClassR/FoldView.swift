//
//  FoldView.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/29/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

@IBDesignable
class FoldView: UIView {

    @IBInspectable var color:UIColor = UIColor.blue
    @IBInspectable var foldColor:UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        var path = UIBezierPath()
        path.lineWidth = CGFloat(1)
        path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
        path.addLine(to: CGPoint(x: CGFloat(bounds.width), y:CGFloat(bounds.height)))
        path.addLine(to: CGPoint(x: CGFloat(bounds.width), y:CGFloat(0)))
        path.close()
        color.setFill()
        path.fill()
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
        path.addLine(to: CGPoint(x: CGFloat(bounds.width), y:CGFloat(bounds.height)))
        path.addLine(to: CGPoint(x: CGFloat(0), y:CGFloat(bounds.height)))
        path.close()
        foldColor.setFill()
        path.fill()
    }

}
