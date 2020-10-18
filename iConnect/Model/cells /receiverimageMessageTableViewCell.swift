//
//  receiverimageMessageTableViewCell.swift
//  iConnect
//
//  Created by Amr Moussa on 10/8/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class receiverimageMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var receiverImage: UIImageView!
    let DB = DBop()
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messagebody: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    var imagelink:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        receiverImage.layer.cornerRadius = receiverImage.frame.width / 2
        receiverImage.clipsToBounds = true
        receiverImage.contentMode = .scaleAspectFill
        
        messageView.layer.cornerRadius = 40
        messageView.clipsToBounds = true
    
       
    }
    override func prepareForReuse() {
          messagebody.text = ""
          timeStampLabel.text = ""
          messageImage.image = nil
          messageImage.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
            imagelink = nil
      }
    override func didMoveToSuperview() {
        if let url = imagelink{
                       DB.fetchimage(url) { (data) in
                           DispatchQueue.main.async {
                             self.messageImage.image = UIImage(data: data!)
                           }
                             
                         }
                     }else{print("nil image url senderrrrr")}
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
