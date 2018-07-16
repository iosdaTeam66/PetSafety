//
//  CloudManager.swift
//  PetSafety
//
//  Created by Giaquinto Alessandro on 16/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import Foundation
import CloudKit

class CloudManager{
    
    static let publicDB = CKContainer.default().publicCloudDatabase
    
    static let privateDB = CKContainer.default().privateCloudDatabase
    
    //    Upload: Public Database -> Pets list
    static func upload(beaconID: String, microchipID: String, name: String, type: String, race: String, birthDate: NSDate){
        let petID = CKRecordID(recordName: beaconID)
        let petRecord = CKRecord(recordType: "Pet", recordID: petID)
        petRecord["birthDate"] = birthDate
        petRecord["microchipID"] = microchipID
        petRecord["name"] = name
        petRecord["race"] = race
        petRecord["type"] = type
        publicDB.save(petRecord){
            (record,error) in
            if let error = error{
//                handling not configured
                return
            }
        }
    }

    //    Upload: Public Database -> Owners list
    static func upload(userID: String, name: String, surname: String, phoneNumber: String, emailAddress: String){
        let userID = CKRecordID(recordName: emailAddress)
        let userRecord = CKRecord(recordType: "Users", recordID: emailAddress)
        userRecord["name"] = name
        userRecord["surname"] = surname
        userRecord["phoneNumber"] = phoneNumber
        userRecord["userID"] = userID
        publicDB.save(petRecord){
            (record,error) in
            if let error = error{
                //                handling not configured
                return
            }
        }
    }

    //    Upload: Public Database -> Missing list
    static func upload(emailAddress: String, beaconID: String){
        let missingID = CKRecordID(recordName: beaconID)
        let missingRecord = CKRecord(recordType: "Missing", recordID: emailAddress)
        missingRecord["emailAddress"] = emailAddress
//        missingRecord["missing_data"] = oggetto date-time -> current timestamp
        publicDB.save(petRecord){
            (record,error) in
            if let error = error{
                //                handling not configured
                return
            }
        }
    }
    
    //    Upload: Public Database -> Coordinate list
    static func upload(beaconID: String, emailAddress: String, location: CLLocation){
        let coordinateID = CKRecordID(recordName: beaconID)
        let coordinateRecord = CKRecord(recordType: "Coordinate", recordID: beaconID)
        coordinateRecord["emailAddress"] = emailAddress
        coordinateRecord["position"] = location
        //        missingRecord["missing_data"] = oggetto date-time -> current timestamp
        publicDB.save(petRecord){
            (record,error) in
            if let error = error{
                //                handling not configured
                return
            }
        }
    }
}
