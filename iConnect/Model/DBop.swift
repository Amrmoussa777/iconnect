//
//  DBop.swift
//  iConnect
//
//  Created by Amr Moussa on 10/1/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
class DBop{
    var currntuser:Firebase.User?{
        return Auth.auth().currentUser        
    }
    
    
    let db = Firestore.firestore()
    
    
    func CheckAuthenticate (_ email:String, _ password:String,callBack: @escaping (Firebase.User?) ->()) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                callBack(nil)
            }else{
                callBack(authResult?.user)
                print("auth user is " + (authResult?.user.email)!)
                
            }
        }
    }
    
    func registerUser(_ email:String,_ password:String,_ username:String,_ image:UIImage?,callBack : @escaping(Firebase.User?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil{
                callBack(nil)
            }
            else{
                if let data = authResult{
                    print(data.user.email!)
                    self.uploadImageToFBaseStrorage(image){(downlink:String) in
                        if downlink == ""{
                            callBack(nil)
                        }else{
                            self.addusertoFireStroe(email,username,downlink){(userId:String) in
                                Auth.auth().addStateDidChangeListener { (auth, user) in
                                    callBack(user)
                                    print("auth user is " + (authResult?.user.email)!)
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        
    }
    
    fileprivate func uploadImageToFBaseStrorage(_ image:UIImage?,callback:@escaping (String)->()){
        let uniqueString = UUID().uuidString
        let storageRef = Storage.storage().reference().child(uniqueString)
        if let uploadData = image!.jpegData(compressionQuality: CGFloat(0.01)){
            DispatchQueue.main.async {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        callback("")
                    }
                    else{
                        storageRef.downloadURL(completion: { (url, error) in
                            callback((url?.absoluteString)!)
                            //                                        print(downlink)
                            //                                        self.addUserdataToFireStrore(email,username,downlink)
                            //
                        })
                    }
                }
            }
        }
    }
    fileprivate func addusertoFireStroe(_ email:String,_ username:String ,_ imageLink:String,callback:@escaping (String) ->()){
        let userData: [String: Any] = [
            const.DB.usernameFeild: username,
            const.DB.lastuctive: Date().timeIntervalSince1970,
            const.DB.iamegelinkfeild: imageLink,
        ]
        db.collection(const.DB.fsUserCollectionname).document(email).setData(userData) { err in
            if let err = err {
                callback(err.localizedDescription)
            } else {
                callback("saved")
            }
        }
        
    }
    
    func fetchFreinds(_ email:String, completion:@escaping ([freindModel]?)->()){
        var freinds:[freindModel] = []
        db.collectionGroup(const.DB.fsUserCollectionname).addSnapshotListener { (snapshot, error) in
            if error != nil{completion(nil)}
            else{
                if let documents = snapshot?.documents{
                    for friendDoc in documents{
                        let data = friendDoc.data()
                        if let name = data[const.DB.usernameFeild],let imgurl = data[const.DB.iamegelinkfeild],let lastActive = data[const.DB.lastuctive] as? Double{
                            let email = friendDoc.documentID
                            let date  = Date(timeIntervalSince1970: lastActive)
                            let df = DateFormatter()
                            df.dateFormat = "EEE, MMM d  hh:mm aaa"
                            let stringDate = df.string(from: date)
                            var ikmgData:Data?
                            self.fetchimage(imgurl as! String) { (data) in
                                ikmgData = data
                                let newFreind = freindModel(email: email, name: name as! String, img: ikmgData!, lastActive: stringDate)
                                freinds.append(newFreind)
                                completion(freinds)
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
    func fetchimage(_ url:String,comppletion: @escaping (Data?)->()){
        let urll = URL(string:url)
        if let chsheImage = ImagesCashe.sharedBinsatance.fetchFromCashe(url){
            print("cashe Hit " + url)
            comppletion(chsheImage)
        }
        else{
            if let linkUrl = urll {
            getIMageData(from: linkUrl) { (data, response, Err) in
                print("cashe Miss " + url)
                guard let data = data , Err == nil else {print("errrrrrrrrrrrrrrrr");return}
                ImagesCashe.sharedBinsatance.addImageToCashe(url, data)
                comppletion(data)
            }
        }
        }
    }
    private func getIMageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //    return convId and messageObjects if old messages found
    func fetchCharmessages(_ email:String,callback:@escaping (String,[Any]?)->()){
        
        print("emailfetch" + (currntuser?.email ?? ""))
        //      auth_
        db.collection(const.DB.fsUserCollectionname).document((currntuser?.email)!).collection(const.DB.conversationsArr).whereField("receiver", isEqualTo: email).getDocuments{ (QuerySnapshot, error) in
            print(print("emailsent" + (self.currntuser?.email ?? "")))
            if error != nil{callback("error",[])}
            else{
                //                list of IDs of chats
                if let documents = QuerySnapshot?.documents{
                    //                    if user has no conversations at all
                    if QuerySnapshot?.documents.count == 0 { print("no found conversation between user and his freind") ; callback("no found conv",[])}
                    for convDoc in documents{
                        //                        check if second user has a mutual chat
                        let id = convDoc.documentID
                        self.db.collection(const.DB.convCollection).document(id).collection(const.DB.convMessagesCollection).order(by: const.DB.messageTimestamp).addSnapshotListener{ (Queryshot, error) in
                            if error != nil{callback("error",[])}else{
                                if let conversation = Queryshot{
                                    if Queryshot?.documents.count == 0 { print("id of conv " + id) ; callback(id,[])}
                                    else{
                                        var messageArr:[Any] = []
                                        if let messages = Queryshot?.documents{
                                            for mess in messages{
                                                let data = mess.data()
                                                if let body = data[const.DB.messageBody],let owner = data[const.DB.messageOwner],let type = data[const.DB.messageType],let timestamp = data[const.DB.messageTimestamp] as? Double{
                                                    if type as! String == const.DB.messageTypes.texttype{
                                                        let newMessage = message(body: body as! String, type: type as! String, timestamp: timestamp, owner: owner as! String)
                                                        messageArr.append(newMessage)
                                                    }
                                                    if type as! String == const.DB.messageTypes.textWithImage{
                                                        if let imgUrl = data[const.DB.iamegelinkfeild] as? String {
                                                            print(imgUrl)
                                                            let imMessage = imageMessage(body: body as! String, type: type as! String, timestamp: timestamp, owner: owner as! String, image:imgUrl)
                                                            messageArr.append(imMessage)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        callback(id,messageArr)
                                        print("messages found with id " + id)
                                        
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    //  completion(freinds)
                    
                    
                }
            }
            
        }
    }
    func createNewConv(_ email:String, callback: @escaping (String , Error?)->()){
        let ref = db.collection(const.DB.convCollection).document()
        //        let messageData:[String:Any][:]
        let convDatadocument = [
            const.DB.convSender:currntuser?.email,
            const.DB.convreceiver:email
        ]
        //        let con:[String:Any] = [
        //            const.DB.convID:"",
        //            const.DB.convreceiver:email
        //        ]
        let id = ref.documentID
        ref.setData(convDatadocument) { (err) in
            if err != nil{callback("", err!)}
            else{
                //      auth_
                self.addConvIDTouser([(self.currntuser?.email)!,email],id){ (error)in
                    if error == nil{
                        callback(id,err)
                    }
                }
            }
            
        }
    }
    
    func addConvIDTouser(_ users:[String],_ convID:String,complete:@escaping (Error?)->()) {
        
        for user in users {
            var data:[String:String] = ["id":convID,"receiver": users[1 - (users.firstIndex(of: user))!]]
            db.collection(const.DB.fsUserCollectionname).document(user).collection(const.DB.conversationsArr).document(convID).setData(data, completion: { (err) in
                if err == nil{
                    complete(err)
                }
            })
            
        }
    }
    func createAddMessageToChat(_ convId:String,_ message:message,callback: @escaping(Error?,Bool)->()){
        
        let addMessageData :[String:Any] = [
            const.DB.messageBody : message.body,
            const.DB.messageType:message.type,
            const.DB.messageTimestamp:message.timestamp,
            const.DB.messageOwner:message.owner,
        ]
        
        db.collection(const.DB.convCollection).document(convId).collection(const.DB.convMessagesCollection).addDocument(data: addMessageData) { (error) in
            if error != nil {print("EROOR adding new message to conv firestore"); callback(error,false)}
            else{
                callback(error,true)
            }
        }
        
        
    }
    func AddImageMessageToChat(_ convId:String,_ message:imageMessage,_ image:UIImage,callback: @escaping(Error?,Bool)->()){
        uploadImageToFBaseStrorage(image) { (imagePath) in
            print("iamge saved  at " + imagePath)
            let addMessageData :[String:Any] = [
                const.DB.messageBody : message.body,
                const.DB.messageType:message.type,
                const.DB.messageTimestamp:message.timestamp,
                const.DB.messageOwner:message.owner,
                const.DB.iamegelinkfeild:imagePath
            ]
            self.db.collection(const.DB.convCollection).document(convId).collection(const.DB.convMessagesCollection).addDocument(data: addMessageData) { (error) in
                if error != nil {print("EROOR adding new image message to conv firestore"); callback(error,false)}
                else{
                    callback(error,true)
                }
            }
        }
        
        
    }
    
    //    func getcurrentUserEmail() ->String?{
    //            return Auth.auth().currentUser?.email
    //        }
    //
    func getcurrentUser(callback:@escaping (freindModel?)->()){
        print(currntuser?.email)
        let useremail = currntuser?.email
        self.db.collection(const.DB.fsUserCollectionname).document(useremail!).getDocument { (DocumentSnapshot, error) in
            if let docData = DocumentSnapshot?.data()
            {
                if error != nil{callback(nil)}
                else{
                    let  lastActive = docData[const.DB.lastuctive] as? Double
                    let date  = Date(timeIntervalSince1970: lastActive!)
                    let df = DateFormatter()
                    df.dateFormat = "EEE, MMM d  hh:mm aaa"
                    let stringDate = df.string(from: date)
                    var imageData:Data?
                    self.fetchimage( docData[const.DB.iamegelinkfeild] as! String) { (data) in
                        imageData = data
                        let newFreind = freindModel(email: useremail!  , name: docData[const.DB.usernameFeild] as! String,img:imageData! , lastActive: stringDate )
                        print(newFreind)
                        callback(newFreind)
                    }
                    
                }
            }
            
            
            
        }
    }
    func fetchConversations(callback:@escaping ([Conversation])->()){
        let group = DispatchGroup()
        self.db.collection(const.DB.fsUserCollectionname).document((currntuser?.email)!).collection(const.DB.conversationsArr).getDocuments { (snapshot, error) in
            if error != nil{print("error loading conversations");return}
            var converArr:[Conversation] = []
            if let conversations = snapshot?.documents{
                for conv in conversations{
                    let convData = conv.data()
                    if  let receiver = convData["receiver"]{
                        let rec = receiver as! String
                        print(rec)
                self.db.collection(const.DB.fsUserCollectionname).document(rec).getDocument { (shot, err) in
                            if err != nil {print("errrrrrrrrrprrprprp")}
                            if let userData = shot?.data(){
                                let userNAme = userData[const.DB.usernameFeild] as!String
                                print(userNAme)
                                let lastActive = userData[const.DB.lastuctive] as!Double
                                group.enter()
                                if  let image = userData[const.DB.iamegelinkfeild] {
                                    self.fetchimage(image as! String) { (data) in
                                        let newconv = Conversation(useremail: userNAme, recevierEmail: receiver as! String, lastTimeStamp: lastActive, convID: conv.documentID, receiverImage:data! )
                                        print(newconv)
                                        converArr.append(newconv)
                                        group.leave()
                                        callback(converArr)
                                    }
                                }
                                group.wait()
                            }
                            
                        }
                    }
                }
               
            }
            print(converArr)
        }
        group.notify(queue: .main) {
        print("Finished all requests.")
                       }
    }
    
    
}


