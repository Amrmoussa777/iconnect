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
    var imagelink:String?{
        didSet{
        reloadImage()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        receiverImage.layer.cornerRadius = receiverImage.frame.width / 2
        receiverImage.clipsToBounds = true
        receiverImage.contentMode = .scaleAspectFill
        messagebody.layer.cornerRadius = 20
        messagebody.clipsToBounds = true
        messageView.layer.cornerRadius = 40
        messageView.clipsToBounds = true
        messageImage.layer.cornerRadius =  40
        messageImage.clipsToBounds = true
        self.setNeedsLayout()
    }
    override func prepareForReuse() {
          messagebody.text = ""
          timeStampLabel.text = ""
          messageImage.image = nil
          messageImage.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
            imagelink = nil
      }
    override func didMoveToSuperview() {
      reloadImage()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadImage(){
        if let url = imagelink{
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
        }else{print("nil image url receiverrr")}
    }
}
