//
//  RestUserService.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 01.09.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous


/*
 Initiates the service calls via REST to manage user services
 */
class RestUserService{
    
    static let INSTANCE = RestUserService()
    
    //standard constructor
    init(){}

    /*
     Function calls REST backend to verify user data. Returns new user including ID.
     */
    func createUser(user: User) -> User? {
        
        //get request URL
        var request = HMAC.jsonRequest(url: "/api/v1/user");
        
        //set parameter
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: user.toJSON(), options: [])
        
        let newUser = Alamofire.request(request).responseObject(User.self)
        
        return newUser
    }

    /*
     Function calls REST backend and returns a user by given ID
     */
    func getUser() -> User? {
        
        let request = HMAC.jsonRequest(url: "/api/v1/user/");
        let userByID = Alamofire.request(request).responseObject(User.self)
        
        return userByID
    }

}


