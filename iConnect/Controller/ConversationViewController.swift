//
//  ConversationViewController.swift
//  iConnect
//
//  Created by Amr Moussa on 9/28/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController,WhichConversationTappedAndtype {
   
    
    
    let DB = DBop()
    var currentUser:freindModel?
    @IBOutlet weak var conversationsTableView: UITableView!
    var conversations:[Conversation]?
    var useremail:String?
    var receiveremail:String?
    var nextChat:[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "Chats"
        navigationItem.largeTitleDisplayMode = .always
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
        conversationsTableView.register(UINib(nibName: const.identifiers.conversationcellnib, bundle: nil), forCellReuseIdentifier: const.identifiers.conversationcell)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.loadconversation()
        }
    }
    
    func loadconversation(){
        DB.fetchConversations { (conversations) in
            if conversations.count != 0 {
                self.conversations = conversations
                         print("conv clasas return")
                DispatchQueue.main.async {
                self.conversationsTableView.reloadData()
                }

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

}
extension ConversationViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let convArr = self.conversations{
            let conversation = convArr[indexPath.row]
            let cell = conversationsTableView.dequeueReusableCell(withIdentifier: const.identifiers.conversationcell, for: indexPath) as! conversationTableViewCell
            cell.freindNameLabel.text = conversation.useremail
            let df = DateFormatter()
             let date  = Date(timeIntervalSince1970: conversation.lastTimeStamp)
            df.dateFormat = "EEE, MMM d  hh:mm aaa"
            let stringDate = df.string(from:date )
            cell.lastActiveLabel.text = stringDate
            cell.freindImageView.image = UIImage(data: conversation.receiverImage)
            cell.covId = conversation.convID
            cell.delegate = self
            cell.tag = indexPath.row
             return cell
            
        }
        return UITableViewCell()
    }
    
  func whichconversatoin(_ convID: String, _ type: String) {
 
        
    
    
    }
    func whichconversatoin(_ convID: String, _ type: String, _ indexRow: Int) {
        nextChat = ["nextID":convID,"type":type,"indexrow":indexRow]
            performSegue(withIdentifier:const.segues.convToChat, sender: self)
       }
       

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if  segue.identifier == const.segues.convToChat{
             let destination = segue.destination as! chatViewController
             destination.conversationId = nextChat["nextID"] as? String
            destination.convType = nextChat["type"] as? String
            let row = nextChat["indexrow"] as? Int
            if let convArr = conversations{
                let conv = convArr[row!]
                let df = DateFormatter()
                 let date  = Date(timeIntervalSince1970: conv.lastTimeStamp)
                df.dateFormat = "EEE, MMM d  hh:mm aaa"
                let stringDate = df.string(from:date )
                destination.reciver = freindModel(email: conv.recevierEmail, name: conv.useremail, img: conv.receiverImage, lastActive: stringDate)
            }
           
         }
     }
    
    
    
}
