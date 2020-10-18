//
//  ImagesCashe.swift
//  iConnect
//
//  Created by Amr Moussa on 10/18/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import Foundation


class ImagesCashe {
    var casheImages:[String:Data?] = [:]
    static let sharedBinsatance  = ImagesCashe()
    
    private init() {
    }
    func addImageToCashe(_ url:String,_ data:Data){
        casheImages[url] = data
        let im = casheImages[url]
        
    }
    func fetchFromCashe(_ url:String)->Data?{
        if let data = casheImages[url]{
            return data
        }
        return nil
    }
}
