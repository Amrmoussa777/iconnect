//
//  senderMessageCell.swift
//  iConnect
//
//  Created by Amr Moussa on 10/3/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class senderMessageCell: UITableViewCell {
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageTimeStamp: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    var imagelink:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        senderImageView.layer.cornerRadius = senderImageView.frame.width / 2
        senderImageView.clipsToBounds = true
        senderImageView.contentMode = .scaleAspectFill
        messageView.layer.cornerRadius = 20
        messageView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
