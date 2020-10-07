//
//  constants.swift
//  iConnect
//
//  Created by Amr Moussa on 5/6/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import Foundation
struct const {
    struct segues {
        static let loginToconversations = "logintoconversations"
        static let registerToconversations = "registertoconversations"
        static let addnewconversation = "addnewconversation"
        static let addtochat = "addtochata"
    }
    struct colors {
        static let registerButtonColor  = "registerbuttoncolor"
    }
    struct DB {
        static let fsUserCollectionname = "users"
        static let useremailfeild = "email"
        static let usernameFeild = "username"
        static let iamegelinkfeild = "imagelink"
        static let conversationsArr = "conversations"
        static let lastuctive = "lastActive"
        static let convID = "convfeild"
        static let convreceiver = "convReciver"
        static let convSender = "convSendr"
        static let convCollection = "convCollection"
        static let messageBody = "message"
        static let messageType = "messageType"
        static let messageTimestamp = "messagetimestamp"
        static let messageOwner = "messageowner"
        static let convMessagesCollection = "messages"
        
        
        
        struct messageTypes {
            static let texttype = "texttype"
            static let textWithImage = "textWithImage"
            static let game = "game"
            
        }
        
    }
    struct  identifiers {
        static let conversationCellID = "conversationCell"
        static let freindsCellID = "freindscell"
        static let freindcellnibname = "freindCell"
        static let senderCell = "sendercell"
        static let sendercellnibname = "senderMessageCell"
        static let receiverCell = "receivermessageCell"
        static let receivercellnibname = "receiverMessageCell"
        
    }
}
