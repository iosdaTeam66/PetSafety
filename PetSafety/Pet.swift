//
//  Pet.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 10/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class Pet: NSObject {
    var name: String
    var race: String
    var type: String
    var photo: String
    var birthDate: Date
    var microchipID: String
    var beaconUUID: String
    let petImageKey: String
//    da aggiungere campo bool isMissing
    
    init(name: String, race: String, type: String, photo: String, birthDate: Date, microchipID: String, beaconUUID: String) {
        self.name = name
        self.race = race
        self.type = type
        self.photo = photo
        self.birthDate = birthDate
        self.microchipID = microchipID
        self.beaconUUID = beaconUUID
        self.petImageKey = UUID().uuidString
    }
}
 
