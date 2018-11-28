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
        status!.liked = !status!.liked
        updateLikeButton()
    }
    func updateLikeButton() {
        if (status!.liked) {
            likeButton.setTitle("Liked", for: .normal)
            likeButton.setTitleColor(UIColor(hexString: "#00A8E8"), for: .normal)
        } else {
            likeButton.setTitle("Like", for: .normal)
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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
