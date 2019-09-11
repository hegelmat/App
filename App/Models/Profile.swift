//
//  Profile.swift
//  App
//
//  Created by user158423 on 8/28/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import Foundation
import UIKit


class Profile {
    
    var picture : String
    var phoneNo : String
    var userStatus : String
    var userID : User

    init(){
        self.picture = ""
        self.phoneNo = ""
        self.userID = User()
        self.userStatus = "Client"
        //super.init()
    }
    init(_ user : User){
        self.picture = ""
        self.phoneNo = ""
        self.userID = user
        self.userStatus = "Client"
        
    }
    init(_ user : User, _ picture: String, _ phoneNo : String, _ userType : String){
        self.picture = picture
        self.phoneNo = phoneNo
        self.userID = user
        self.userStatus = "Client"
    }
    
}
