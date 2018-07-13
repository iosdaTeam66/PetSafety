//
//  User.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 11/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String
    var surname: String
    var phoneNumber: String
    var emailAddress: String
    var userID: String
    
    init(name: String, surname: String, phoneNumber: String, emailAddress: String, userID: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.userID = userID
    }
    
}
