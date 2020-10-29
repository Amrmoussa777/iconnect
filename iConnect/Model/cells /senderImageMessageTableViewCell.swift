//
//  senderImageMessageTableViewCell.swift
//  iConnect
//
//  Created by Amr Moussa on 10/8/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class senderImageMessageTableViewCell: UITableViewCell {
    let DB = DBop()
    @IBOutlet weak var messagebody: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var senderimage: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    var imagelink:String?{
        didSet{
            reloadimage()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        senderimage.layer.cornerRadius = senderimage.frame.width / 2
        senderimage.clipsToBounds = true
        senderimage.contentMode = .scaleAspectFill
        messageImage.layer.cornerRadius =
            messageImage.frame.width / 10
        messageImage.clipsToBounds = true
        messageView.layer.cornerRadius =  30
        messageView.clipsToBounds = true
        messagebody.layer.cornerRadius = 20
        messagebody.clipsToBounds = true

    }
    override func didMoveToSuperview() {
       reloadimage()
    }
    override func prepareForReuse() {
        messagebody.text = ""
        timestampLabel.text = ""
        messageImage.image = nil
        messageImage.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        imagelink = nil
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadimage(){
        if let url = imagelink{
        print("new link in did move" + "\(self.tag)" + url)
               DB.fetchimage(url) { (data) in
                   DispatchQueue.main.async {
                    self.messageImage.image = UIImage(data: data!)
                    self.messageImage.contentMode = .scaleAspectFill
                    self.messageImage.layer.cornerRadius =
                        self.messageImage.frame.width / 10
                    self.messageImage.clipsToBounds = true
                    self.setNeedsLayout()
                   }
               }
           }else{print("nil image url senderrrrr")}
        
        
    }
    
}
