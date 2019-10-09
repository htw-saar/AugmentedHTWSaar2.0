//
//  User.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 01.09.19
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import Foundation

struct User: Codable{
    
    static var current:User = User(apiUser: "peter", apiSecret: "secret")
    
    var id:String? = "0"
    var apiUser: String?
    var apiSecret: String?
    var eMail:String?
    var firstName:String?
    var lastName:String?
    var role:Int?
    
    init(){
        
    }
    
    init(id: String = "0",apiUser: String, apiSecret: String){
        self.id = id
        self.apiUser = apiUser
        self.apiSecret = apiSecret
    }
    
    //parses user object to JSON type String
    func toJSON() -> [String: Any] {
        return [
                "apiSecret": apiSecret as Any,
                "apiUser": apiUser as Any,
                "eMail": eMail as Any,
                "firstName": firstName as Any,
                "id": id as Any,
                "lastName": lastName as Any,
                "role": role as Any
        ]
    }


}
