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
    }
    struct  identifiers {
        static let conversationCellID = "conversationCell"
        static let freindsCellID = "freindscell"
        static let freindcellnibname = "freindCell"
    }
}
