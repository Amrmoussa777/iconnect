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
    //    let  user  = Firebase.User.Type.self
    let db = Firestore.firestore()
    func CheckAuthenticate (_ email:String, _ password:String,callBack: @escaping (Firebase.User?) ->()) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                callBack(nil)
            }else{
                callBack(authResult?.user)
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
                                callBack(authResult?.user)
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
        if let uploadData = image!.jpegData(compressionQuality: CGFloat(0.5)){
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
            const.DB.conversationsArr: []
        ]
        db.collection(const.DB.fsUserCollectionname).document(email).setData(userData) { err in
            if let err = err {
                callback("")
            } else {
                callback("saved")
            }
        }
        
    }
    
    func fetchFreinds(_ email:String, completion:@escaping ([freindModel]?)->()){
        var freinds :[freindModel] = []
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
                            let newFreind = freindModel(email: email, name: name as! String, imgUrl: imgurl as! String, lastActive: stringDate)
                            freinds.append(newFreind)
                        }
             
                    }
                    completion(freinds)
                    
                }
                
                
            }
        }
        
        
    }
    func fetchimage(_ url:String,comppletion: @escaping (Data?)->()){
        let urll = URL(string:url)
        getIMageData(from: urll!) { (data, response, Err) in
            guard let data = data , Err == nil else {return}
            comppletion(data)
        }
    }
    private func getIMageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
