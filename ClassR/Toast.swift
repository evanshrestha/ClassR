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
    var lbl:UILabel = UILabel()
    
    init(text:String) {
        
        let vc = UIApplication.shared.keyWindow!
        
        let height = CGFloat(64)
        lbl.text = text
        lbl.backgroundColor = UIColor(hexString: "#80DBFF")
        lbl.textColor = UIColor.white
        lbl.font = UIFont.init(descriptor: UIFontDescriptor(name: "Open Sans", size: CGFloat(24)), size: CGFloat(24))
        lbl.textAlignment = .center
        
        //Step 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        //Step 2
        vc.addSubview(lbl)
        
        //Step 3
//        NSLayoutConstraint.activate([
//
//            lbl.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor),
//            lbl.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor),
//            lbl.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor,constant: -height),
//            lbl.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor),
//            ])
//        self.lbl.alpha = 0
        
        self.lbl.frame.size.height = height
        self.lbl.frame.origin.x = 0
        self.lbl.frame.size.width = UIScreen.main.bounds.width
        self.lbl.frame.origin.y = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.lbl.frame.origin.y = UIScreen.main.bounds.height - height
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseInOut, animations: {
            self.lbl.frame.origin.y = UIScreen.main.bounds.height
            }, completion: { (_) in
            self.lbl.removeFromSuperview()
            })}
        )
        
    }
}
