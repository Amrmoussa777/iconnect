//
//  receiverMessageCell.swift
//  iConnect
//
//  Created by Amr Moussa on 10/3/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class receiverMessageCell: UITableViewCell {

    @IBOutlet weak var receiverImageview: UIImageView!
    @IBOutlet weak var messagebody: UILabel!
    @IBOutlet weak var messageTimeStamp: UILabel!
    @IBOutlet weak var messageView: UIView!
    var imagelink:String? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        receiverImageview.layer.cornerRadius = receiverImageview.frame.width / 2
             receiverImageview.clipsToBounds = true
             receiverImageview.contentMode = .scaleAspectFill
             messageView.layer.cornerRadius = 20
             messageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
