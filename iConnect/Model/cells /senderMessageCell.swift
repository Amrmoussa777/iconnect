//
//  senderMessageCell.swift
//  iConnect
//
//  Created by Amr Moussa on 10/3/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class senderMessageCell: UITableViewCell {

    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageTimeStamp: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
