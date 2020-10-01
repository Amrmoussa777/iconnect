//
//  freindCell.swift
//  iConnect
//
//  Created by Amr Moussa on 9/28/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class freindCell: UITableViewCell {

    @IBOutlet weak var freindNameLabel: UILabel!
    @IBOutlet weak var freindImageView: UIImageView!
    @IBOutlet weak var addMessageButton: UIButton!
    @IBOutlet weak var lastActiveLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
struct freindModel{
    let email:String
    let name :String
    let imgUrl:String
    let lastActive:String
}
