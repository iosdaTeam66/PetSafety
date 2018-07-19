//
//  CloudManager.swift
//  PetSafety
//
//  Created by Giaquinto Alessandro on 16/07/18.
//  Copyright © 2018 Giaquinto Alessandro. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

class CloudManager{
    static let publicDB = CKContainer.default().publicCloudDatabase
    //    Select
    //    Ricorda, se la ricerca non produce risultati, l'array restituito può essere vuoto nil
    static func selectPosition(rcdTp: String, fieldName: String, searched: String) -> [(pos: CLLocation, email: String, date: String)]{
        var arr = [(pos: CLLocation, email: String, date: String)]()
        let pred = NSPredicate(format: "\(fieldName) == \"\(searched)\"")
        let userQuery = CKQuery(recordType: rcdTp, predicate: pred)
        publicDB.perform(userQuery, inZoneWith: nil, completionHandler: ({results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            } else {
                if results!.count > 0 {
                    DispatchQueue.main.async {
                        print("Query correctly executed")
                        var i = 0
                        for entry in results!{
                            arr[i].pos = entry["position"] as! CLLocation
                            arr[i].email = entry["emailAddress"] as! String
                            arr[i].date = entry["findinfDate"] as! String
                            i+=1
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Not found")
                    }
                }
            }
        }))
        return arr
    }
    
    /*static func select(recordType: String, fieldName: String, searched: String) -> Array<CKRecord>{
        var arr = [CKRecord]()
        let pred = NSPredicate(format: fieldName + " == " + "\"" + searched + "\"" )
        let userQuery = CKQuery(recordType: recordType, predicate: pred)
        publicDB.perform(userQuery, inZoneWith: nil, completionHandler: ({results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            } else {
                if results!.count > 0 {
                    DispatchQueue.main.async {
                        print("Query correctly executed")
                        arr = results!
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Not found")
                    }
                }
            }
        }))
        return arr
    }*/
    
    static func select(recordType: String, fieldName: String, searched: String) -> [(k: String, v: String)]{
        var arr = [(k: String, v: String)]()
        let pred = NSPredicate(format: "\(fieldName) == \"\(searched)\"")
        let userQuery = CKQuery(recordType: recordType, predicate: pred)
        publicDB.perform(userQuery, inZoneWith: nil, completionHandler: ({results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            } else {
                if results!.count > 0 {
                    DispatchQueue.main.async {
                        for result in results! {
                            let prova = result.allKeys()
                            let numCol = prova.count-1
                            for index in 0...numCol {
                                print("ciclo \(index) + \(String(describing: result.value(forKey: prova[index])!))")
                                arr.append((k: prova[index], v: String(describing: result.value(forKey: prova[index])!)))
                            }
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Not found")
                    }
                }
            }
        }))
        print("salvo")
        print(arr.count)
        return arr
    }
    
    //    Upload: Public Database -> Owners list
    static func insert(userID: String, name: String, surname: String, phoneNumber: String, emailAddress: String) -> Bool{
        var retValue = true;
        let userRecord = CKRecord(recordType: "Owners")
        print(userRecord.recordID)
        print(userRecord.allKeys())
        userRecord["emailAddress"] = emailAddress as CKRecordValue
        userRecord["name"] = name as CKRecordValue
        userRecord["surname"] = surname as CKRecordValue
        userRecord["phoneNumber"] = phoneNumber as CKRecordValue
        userRecord["UserID"] = userID as CKRecordValue
        print(userRecord)
        publicDB.save(userRecord){
            (userRecord,error) in
            if error != nil{
                print("DB ERROR")
                retValue = false
            }
        }
        return retValue
    }
    
    //    Upload: Public Database -> Pets list
    static func insert(beaconID: String, microchipID: String, name: String, type: String, race: String, birthDate: NSDate, ownerID: String) -> Bool{
        var retValue = true
        let petRecord = CKRecord(recordType: "Pet")
        petRecord["beaconID"] = beaconID as CKRecordValue
        petRecord["microchipID"] = microchipID as CKRecordValue
        petRecord["name"] = name as CKRecordValue
        petRecord["type"] = type as CKRecordValue
        petRecord["race"] = race as CKRecordValue
        petRecord["birthDate"] = birthDate as CKRecordValue
        petRecord["ownerID"] = ownerID as CKRecordValue
        publicDB.save(petRecord){
            (petRecord,error) in
            if error != nil{
                print("DB ERROR")
                retValue = false
            }
        }
        return retValue
    }
    
    //    Upload: Public Database -> Missing list
    //    La chiave primaria qui è il beaconID
    static func insert(beaconID: String, emailAddress: String) -> Bool{
        var retValue = true;
        let missingRecord = CKRecord(recordType: "Missing")
        missingRecord["beaconID"] = beaconID as CKRecordValue
        missingRecord["emailAddress"] = emailAddress as CKRecordValue
        publicDB.save(missingRecord){
            (missingRecord,error) in
            if error != nil{
                print("DB ERROR")
                retValue = false
            }
        }
        return retValue
    }
    
    //    Upload: Public Database -> Coordinate list
    static func insert(beaconID: String, emailAddress: String, location: CLLocation, findingDate: Date) -> Bool{
        var retValue = true;
        let coordinateRecord = CKRecord(recordType: "Coordinate")
        coordinateRecord["beaconID"] = beaconID as CKRecordValue
        coordinateRecord["emailAddress"] = emailAddress as CKRecordValue
        coordinateRecord["position"] = location as CKRecordValue
        coordinateRecord["findinfDate"] = findingDate as CKRecordValue
        publicDB.save(coordinateRecord){
            (coordinateRecord,error) in
            if error != nil{
                print("DB ERROR")
                retValue = false
            }
        }
        return retValue
    }
    
}
