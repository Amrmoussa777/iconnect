//
//  conversationTableViewCell.swift
//  iConnect
//
//  Created by Amr Moussa on 10/9/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class conversationTableViewCell: UITableViewCell {
    var covId:String?
   
    @IBOutlet weak var freindImageView: UIImageView!
    @IBOutlet weak var freindNameLabel: UILabel!
    
    @IBOutlet weak var lastActiveLabel: UILabel!
    
    @IBOutlet weak var view: UIView!
    
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var playGameBurtton: UIButton!
    @IBOutlet weak var sendIMageButton: UIButton!
    var delegate:WhichConversationTappedAndtype?
    @IBAction func sendBurronPressed(_ sender: Any) {
        delegate!.whichconversatoin(covId!, const.DB.messageTypes.texttype,tag)
    }
    @IBAction func imageButtonPressed(_ sender: Any) {
        delegate!.whichconversatoin(covId!, const.DB.messageTypes.textWithImage,tag)
        
       }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        freindImageView.layer.cornerRadius = freindImageView.frame.height / 2
        freindImageView.contentMode = .scaleAspectFill
        freindImageView.clipsToBounds = true
        view.layer.cornerRadius = freindImageView.frame.height / 2
        view.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
protocol WhichConversationTappedAndtype{
    func whichconversatoin(_ convID:String,_ type:String,_ indexRow:Int)
}
