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
    @IBOutlet weak var ribbonView: RibbonView!
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var foldView: FoldView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var status : Status?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func onDoubleTap(sender: UIGestureRecognizer){
        onLike()
        let pulse = Pulsing(numberOfPulses: 1, radius: 90, position: sender.location(in: newsView))
        if (status!.liked) {
            pulse.animationDuration = 0.8
            pulse.backgroundColor = UIColor(hexString: "#00A8E8").cgColor
        } else {
            pulse.animationDuration = 0.4
            pulse.backgroundColor = UIColor(hexString: "#6F7179").cgColor
        }
        self.layer.insertSublayer(pulse, above: newsView.layer)
    }
    
    @objc func onFoldTap(sender: UIGestureRecognizer) {
        
        if (self.foldView.bounds.contains(sender.location(in: self.foldView))) {
            if (!status!.saved) {
                self.foldView.alpha = 1
                let _ = Toast(text: "Saved")
                self.status!.onSave()
            } else {
                self.foldView.alpha = 0
                let _ = Toast(text: "Unsaved")
                self.status!.onUnsave()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        let foldTapGesture = UITapGestureRecognizer(target: self, action: #selector(onFoldTap(sender:)))
        addGestureRecognizer(foldTapGesture)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLikeButton() {
        if (status!.liked) {
            likeButton.setTitle("Liked", for: .normal)
            likeCountLabel.textColor = UIColor(hexString: "#00A8E8")
            likeButton.setTitleColor(UIColor(hexString: "#00A8E8"), for: .normal)
        } else {
            likeButton.setTitle("Like", for: .normal)
            likeCountLabel.textColor = UIColor(hexString: "#6F7179")
            likeButton.setTitleColor(UIColor(hexString: "#6F7179"), for: .normal)
        }
    }
    
    @IBAction func onLikeTap(_ sender: Any) {
        onLike()
    }
    
    func onLike() {
        status!.onLike()
        updateLikeButton()
        self.likeCountLabel.text = String(status!.likeCount)
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
