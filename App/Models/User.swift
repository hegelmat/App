//
//  User.swift
//  App
//
//  Created by user158423 on 8/28/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import Foundation
import Parse


class User {
    
    var userName : String;
    var userPassword : String;
    var userEmail : String;
    
    init() {
        self.userName = ""
        self.userPassword = ""
        self.userEmail =  ""
    }
    init(_ userName: String ,_ userPassword : String,_ userEmail: String ) {
        self.userName = userName
        self.userPassword = userPassword
        self.userEmail =  userEmail
    }
    
    func setUser( _ userName:String) {
        self.userName = userName
    }
    func setUser( _ userName:String ,_ userPassword: String) {
        self.userName = userName
        self.userPassword = userPassword
    }
    func setUser( _ userName:String ,_ userPassword: String, _ userEmail: String) {
        self.userName = userName
        self.userPassword = userPassword
        self.userEmail = userEmail
    }
    func getUser() -> User{
        return User (self.userName, self.userEmail, self.userPassword)
    }
    

    
    
}
