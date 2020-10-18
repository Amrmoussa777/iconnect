//
//  message.swift
//  iConnect
//
//  Created by Amr Moussa on 9/28/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import Foundation
import  UIKit
struct message{
    let body:String
    let type:String
    let timestamp:Double
    var  stringtimestamp:String{
       let date  = Date(timeIntervalSince1970: timestamp)
        let df = DateFormatter()
        df.dateFormat = "EEE, MMM d  hh:mm aaa"
        let stringDate = df.string(from: date)
        return stringDate
    }
    let owner:String
}

struct imageMessage{
    let body:String
    let type:String
    let timestamp:Double
    var  stringtimestamp:String{
       let date  = Date(timeIntervalSince1970: timestamp)
        let df = DateFormatter()
        df.dateFormat = "EEE, MMM d  hh:mm aaa"
        let stringDate = df.string(from: date)
        return stringDate
    }
    let owner:String
    let image:String
}

 struct gameMessage{
     let body:String
     let type:String
     let timestamp:Double
     var  stringtimestamp:String{
        let date  = Date(timeIntervalSince1970: timestamp)
         let df = DateFormatter()
         df.dateFormat = "EEE, MMM d  hh:mm aaa"
         let stringDate = df.string(from: date)
         return stringDate
     }
     let owner:String
//    add game specs here or add more properties
 }

