//
//  NewsTableViewCell.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/8/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var newsContentView: UIView!
    
    var status : Status?
    
    var liked : Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func onDoubleTap(sender: UIGestureRecognizer){
        onLike()
        let pulse = Pulsing(numberOfPulses: 1, radius: 90, position: sender.location(in: newsView))
        if (liked) {
            pulse.animationDuration = 0.8
            pulse.backgroundColor = UIColor(hexString: "#00A8E8").cgColor
        } else {
            pulse.animationDuration = 0.4
            pulse.backgroundColor = UIColor(hexString: "#6F7179").cgColor
        }
        self.layer.insertSublayer(pulse, above: newsView.layer)
        
        print(UIDevice.current.identifierForVendor!.uuidString)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLikeButton() {
        if (liked) {
            likeButton.setTitle("Liked", for: .normal)
            likeButton.setTitleColor(UIColor(hexString: "#00A8E8"), for: .normal)
        } else {
            likeButton.setTitle("Like", for: .normal)
            likeButton.setTitleColor(UIColor(hexString: "#6F7179"), for: .normal)
        }
    }
    
    @IBAction func onLikeTap(_ sender: Any) {
        onLike()
    }
    
    func onLike() {
        liked = !liked
        updateLikeButton()
    }
    
    @IBAction func onCommentsTap(_ sender: Any) {
        NewsViewController.selectedStatus = self.status
    }
    
}
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}