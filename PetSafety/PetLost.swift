//
//  PetsLost.swift
//  PetSafety
//
//  Created by Marciano Filippo on 13/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class PetLost: NSObject {
    
    var lostDate: Date
    var microchipID: String
    var beaconUUID: String
    var ownerID: String
    
    init(lostDate: Date, microchipID: String, beaconUUID: String, ownerID: String) {
        self.lostDate = lostDate
        self.microchipID = microchipID
        self.beaconUUID = beaconUUID
        self.ownerID = ownerID
    }

}
