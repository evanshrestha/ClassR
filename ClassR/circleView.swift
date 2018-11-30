//
//  CircleView.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/26/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    var color = UIColor.blue
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: bounds)
        color.setFill()
        path.fill()
        
    }
}
