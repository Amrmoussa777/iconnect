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
    var convID:String?
    let DB = DBop()
    var messages:[message] = []
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var selcetImageButton: UIButton!
    @IBOutlet weak var messageTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DB.getcurrentUser(callback: { (friend) in
            if let freind = friend{
                self.Currentuser = freind
                self.loadmessagesTotableView()
                print("sdssss/(freind)")
            }
        })
        print(reciver?.email ?? "")
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self 
        messagesTableView.register(UINib(nibName: const.identifiers.sendercellnibname, bundle: nil), forCellReuseIdentifier: const.identifiers.senderCell)
        messagesTableView.register(UINib(nibName: const.identifiers.receivercellnibname, bundle: nil), forCellReuseIdentifier: const.identifiers.receiverCell)
        // Do any additional setup after loading the view.
        
    
    
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        let mes = message(body: messageTextFeild.text!, type: const.DB.messageTypes.texttype, timestamp: Date().timeIntervalSince1970, owner: (self.Currentuser?.email)!)
        DB.createAddMessageToChat(conversationId!,mes){ (err,didSelectd) in
            if err != nil {print("error");return}
            else{
                self.loadmessagesTotableView()
            }
            
        }
        
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
                            self.messagesTableView.reloadData()
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
        print(message)
        print(Currentuser)
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
        return UITableViewCell()
    }
    

    
    
}
