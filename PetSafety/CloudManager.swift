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
        petRecord["birthDate"] = birthDate as CKRecordValue
        petRecord["microchipID"] = microchipID as CKRecordValue
        petRecord["name"] = name as CKRecordValue
        petRecord["race"] = race as CKRecordValue
        petRecord["type"] = type as CKRecordValue
        publicDB.save(petRecord){
            (record,error) in
            if error != nil{
//                handling not configured
                return
            }
        }
    }

    //    Upload: Public Database -> Owners list
    static func upload(userID: String, name: String, surname: String, phoneNumber: String, emailAddress: String){
        let userID = CKRecordID(recordName: emailAddress)
        let userRecord = CKRecord(recordType: "Users", recordID: userID)
        userRecord["name"] = name as CKRecordValue
        userRecord["surname"] = surname as CKRecordValue
        userRecord["phoneNumber"] = phoneNumber as CKRecordValue
        userRecord["userID"] = userID as? CKRecordValue
        publicDB.save(userRecord){
            (record,error) in
            if error != nil{
                //                handling not configured
                return
            }
        }
    }

    //    Upload: Public Database -> Missing list
    static func upload(emailAddress: String, beaconID: String){
        let missingID = CKRecordID(recordName: beaconID)
        let missingRecord = CKRecord(recordType: "Missing", recordID: missingID)
        missingRecord["emailAddress"] = emailAddress as CKRecordValue
//        missingRecord["missing_data"] = oggetto date-time -> current timestamp
        publicDB.save(missingRecord){
            (record,error) in
            if error != nil{
                //                handling not configured
                return
            }
        }
    }
    
    //    Upload: Public Database -> Coordinate list
    static func upload(beaconID: String, emailAddress: String, location: CLLocation){
        let coordinateID = CKRecordID(recordName: beaconID)
        let coordinateRecord = CKRecord(recordType: "Coordinate", recordID: coordinateID)
        coordinateRecord["emailAddress"] = emailAddress as CKRecordValue
        coordinateRecord["position"] = location as CKRecordValue
        //        missingRecord["missing_data"] = oggetto date-time -> current timestamp
        publicDB.save(coordinateRecord){
            (record,error) in
            if error != nil{
                //                handling not configured
                return
            }
        }
    }
}
