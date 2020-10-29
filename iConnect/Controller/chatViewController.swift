//
//  chatViewController.swift
//  iConnect
//
//  Created by Amr Moussa on 9/28/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class chatViewController: UIViewController {
    var Currentuser:freindModel?
    var conversationId:String?
    var reciver :freindModel?
    let DB = DBop()
    var messages:[Any] = []
    var convType:String?
    let imagePicker =  UIImagePickerController()    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var selcetImageButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DB.getcurrentUser(callback: { (friend) in
            if let freind = friend{
                self.Currentuser = freind
                if let type = self.convType{
                    if type == const.DB.messageTypes.textWithImage{
                        self.selcetImageButton.sendActions(for: .touchUpInside)
                    }
                    
                }
                self.loadmessagesTotableView()
                print("sdssss/(freind)")
            }
        })
        imagePicker.delegate = self
        print(reciver?.email ?? "")
        messagesTableView.dataSource = self
        messagesTableView.delegate = self 
        messagesTableView.register(UINib(nibName: const.identifiers.sendercellnibname, bundle: nil),
                                   forCellReuseIdentifier: const.identifiers.senderCell)
        messagesTableView.register(UINib(nibName: const.identifiers.receivercellnibname, bundle: nil), forCellReuseIdentifier: const.identifiers.receiverCell)
        messagesTableView.register(UINib(nibName: const.identifiers.senderiamgenib, bundle: nil), forCellReuseIdentifier: const.identifiers.senderimagecell)
        messagesTableView.register(UINib(nibName: const.identifiers.receiveriamgenib, bundle: nil),
                                   forCellReuseIdentifier: const.identifiers.receiverimagecell)
        // Do any additional setup after loading the view.
        navigationItem.title = reciver?.name

    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendButton.tintColor? = #colorLiteral(red: 0.2335141599, green: 0.2789170742, blue: 0.3355808258, alpha: 0.6732930223)
        sendButton.isUserInteractionEnabled = false
        let mes = message(body: messageTextFeild.text!, type: const.DB.messageTypes.texttype, timestamp: Date().timeIntervalSince1970, owner: (self.Currentuser?.email)!)
        DB.createAddMessageToChat(conversationId!,mes){ (err,didSelectd) in
            if err != nil {print("error")
                self.sendButton.tintColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.sendButton.isUserInteractionEnabled = true
            return}
            else{
                self.messageTextFeild.text = ""
                self.loadmessagesTotableView()
            }
            
        }
        
    }
    
    @IBAction func selectImageButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func loadmessagesTotableView(){
        sendButton.tintColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sendButton.isUserInteractionEnabled = true
        print("recevier email " + (reciver?.email)!)
        DB.fetchCharmessages((reciver?.email)!) { (convId,retreivedMessages) in
            if convId == "error" {print("errormnmn")}
            else{
                if retreivedMessages?.isEmpty == true {
                    if convId == "no found conv"{
                        self.DB.createNewConv((self.reciver?.email)!){(newconvId,error) in
                            self.conversationId = newconvId
                            print("new chat addded with id \(self.conversationId!)")
                        }
                        
                    }else {
                        self.conversationId = convId
                    }
                    
                }else if retreivedMessages?.isEmpty != true {
                    self.conversationId = convId
                    self.messages = retreivedMessages!
                    DispatchQueue.main.async {
                        self.messagesTableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }
            }
        }
        
        
    }
}
extension chatViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if let message = message as? message {
            print(message)
            if message.type == const.DB.messageTypes.texttype && message.owner == Currentuser?.email{
                let cell = tableView.dequeueReusableCell(withIdentifier: const.identifiers.senderCell, for: indexPath) as! senderMessageCell
                cell.messageTimeStamp.text = message.stringtimestamp
                cell.messageBody.text = message.body
                cell.senderImageView.image = UIImage(data: (self.Currentuser?.img)!)
                return cell
                
            }else if message.type == const.DB.messageTypes.texttype && message.owner == reciver?.email{
                let  cell = tableView.dequeueReusableCell(withIdentifier: const.identifiers.receiverCell) as! receiverMessageCell
                cell.messageTimeStamp.text = message.stringtimestamp
                cell.messagebody.text = message.body
                cell.receiverImageview.image = UIImage(data: (reciver?.img)!)
                return cell
            } 
            
        }else if let message = message as? imageMessage{
            let gruop = DispatchGroup()
            if message.type == const.DB.messageTypes.textWithImage && message.owner == Currentuser?.email{
                let cell = tableView.dequeueReusableCell(withIdentifier: const.identifiers.senderimagecell, for: indexPath) as!
                    senderImageMessageTableViewCell
                cell.timestampLabel.text = message.stringtimestamp
                cell.messagebody.text = message.body
                cell.senderimage.image = UIImage(data: (self.Currentuser?.img)!)
                cell.imagelink = message.image
//                gruop.enter()
//                DB.fetchimage(message.image) { (data) in
//                    DispatchQueue.main.async {
//                       // cell.messageImage.image = UIImage(data: data!)
//                    }
//                    gruop.leave()
//                }
//                gruop.wait()
                
               return cell
                
            }else if message.type == const.DB.messageTypes.textWithImage && message.owner == reciver?.email{
                let cell = tableView.dequeueReusableCell(withIdentifier: const.identifiers.receiverimagecell, for: indexPath) as! receiverimageMessageTableViewCell
                cell.timeStampLabel.text = message.stringtimestamp
                cell.messagebody.text = message.body
                cell.receiverImage.image = UIImage(data: (reciver?.img)!)
                cell.imagelink = message.image
//                gruop.enter()
//                DB.fetchimage(message.image) { (data) in
//                    DispatchQueue.main.async {
//                       // cell.messageImage.image = UIImage(data: data!)
//                    }
//                gruop.leave()
//                    }
//                gruop.wait()
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    
    
    
}
extension chatViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let newMessage = imageMessage(body: messageTextFeild.text?.count == 0 ? "New Image":messageTextFeild.text!, type: const.DB.messageTypes.textWithImage, timestamp: Date().timeIntervalSince1970, owner: (Currentuser?.email)!, image: "")
            DB.AddImageMessageToChat(conversationId!, newMessage, pickedImage) { (err, saved) in
                if saved == true{
                    self.loadmessagesTotableView()
                }
            }
            
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
