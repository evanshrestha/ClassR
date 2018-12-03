//
//  NewsImageTableViewCell.swift
//  ClassR
//
//  Created by Evan Shrestha on 11/27/18.
//  Copyright © 2018 Evan Shrestha. All rights reserved.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {
    
    // Store status
    var status: Status?
    
    // Add views
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var ribbonView: RibbonView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var foldView: FoldView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBAction func onCommentsClick(_ sender: Any) {
        NewsViewController.selectedStatus = self.status
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func onLikeTap(_ sender: Any) {
        onLike()
    }
    
    func onLike() {
        status!.onLike()
        updateLikeButton()
        self.likeCountLabel.text = String(status!.likeCount)
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
    
}
