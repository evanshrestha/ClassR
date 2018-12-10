//
//  Toast.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/29/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import Foundation
import UIKit

class Toast {
    
    var animationGroup = CAAnimationGroup()
    static var toastLbls : Array<UILabel> = []
    
    static func remove() {
        for lbl in toastLbls {
            lbl.removeFromSuperview()
        }
        toastLbls.removeAll()
    }
    
    init(text:String) {
        
        let vc = UIApplication.shared.keyWindow!
        let lbl = UILabel()
        
        
        let height = CGFloat(64)
        lbl.text = text
        lbl.backgroundColor = UIColor(hexString: "#80DBFF")
        lbl.textColor = UIColor.white
        lbl.font = UIFont.init(descriptor: UIFontDescriptor(name: "Open Sans", size: CGFloat(24)), size: CGFloat(24))
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        vc.addSubview(lbl)
        lbl.frame.size.height = height
        lbl.frame.origin.x = 0
        lbl.frame.size.width = UIScreen.main.bounds.width
        lbl.frame.origin.y = UIScreen.main.bounds.height
        Toast.toastLbls.append(lbl)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            lbl.frame.origin.y = UIScreen.main.bounds.height - height
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseInOut, animations: {
            lbl.frame.origin.y = UIScreen.main.bounds.height
            }, completion: { (_) in
            lbl.removeFromSuperview()
            })}
        )
        
    }
}
