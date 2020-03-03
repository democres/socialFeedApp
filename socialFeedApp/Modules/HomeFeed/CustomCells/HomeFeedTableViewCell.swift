//
//  HomeFeedTableViewCell.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var authorNickLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var authorPictureImg: UIImageView!
    @IBOutlet weak var socialNetworkIcon: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
    // MARK: - init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
