//
//  WallCell.swift
//  Myinsta
//
//  Created by Nanxin Jin on 3/19/17.
//  Copyright © 2017 Nanxin Jin. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class WallCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post: PFObject! {
        willSet {
            self.postImageView.file = newValue["media"] as? PFFile
            self.postImageView.loadInBackground()
            self.descriptionLabel.text = newValue["caption"] as? String
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
