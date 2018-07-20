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
    static var userDB = [(k: String, v: String)]()
    //    static var positionDB = [(beaconID: String, emailAddress: String, position: CLLocation, foundIt: Date)]
    //    Select
    //    Ricorda, se la ricerca non produce risultati, l'array restituito può essere vuoto nil
    static func selectPosition(rcdTp: String, fieldName: String, searched: String, index: Int) {
        //positionDB.removeAll()
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
                        for result in results! {
                            let date = result.value(forKey: "findinfDate") as? NSDate ?? NSDate()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                            let dateString = dateFormatter.string(from: date as Date)
                            print(dateString)
                            MyPetListViewController.positionDB.append((pos: result.value(forKey: "position") as! CLLocation, email: result.value(forKey: "emailAddress") as! String, date: dateString, index))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Not found")
                    }
                }
            }
        }))
        
    }
    
    static func update(recordType: String, recordName: String, oldValue: String, newValue: String){
        var ctUsers = [CKRecord]()
        let predicate = NSPredicate(format: "\(recordName) == \"\(oldValue)\"")
        let query = CKQuery(recordType: recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil, completionHandler:  ({results, error in
            if error != nil {
                print("NO ERROR")
            }
            if let users = results {
                ctUsers = users
                print("\nSELECT RETURN VALUE?\n")
                if ctUsers.count != 0 {
                    let user =  users.first
                    user?[recordName] = newValue as CKRecordValue
                    publicDB.save(user!, completionHandler: ({record, error in
                        if error == nil {
                            print("\nUPDATE SUCCESSFULLY\n")
                        }else {
                            print("\nDB ERROR\n")
                        }
                    }))
                }else{
                    print("\nNOT FOUND\n")
                }
            }
        }))
    }
    
    static func selectPet(recordType: String, fieldName: String, searched: String){
        //userDB.removeAll()
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
                            let pet : Pet = Pet(name: result.value(forKey: "name") as! String, race: result.value(forKey: "race") as! String, type: result.value(forKey: "type") as! String, photo: "", birthDate: Date(), microchipID: result.value(forKey: "ownerID") as! String, beaconUUID: result.value(forKey: "beaconID") as! String)
                            if !BeaconManager.petList.contains(pet) {
                                BeaconManager.petList.append(pet)
                                print("pet inserito \(pet.beaconUUID)\n\n\n")
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
    }
    
    
    
    static func select(recordType: String, fieldName: String, searched: String){
        userDB.removeAll()
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
                                userDB.append((k: prova[index], v: String(describing: result.value(forKey: prova[index])!)))
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
    }
    
    static func selectMissing(recordType: String){
        
        let pred = NSPredicate(value: true)
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
                            //let prova = result.allKeys()
                                //print("ciclo \(index) + \(String(describing: result.value(forKey: prova[index])!))")
                            BeaconManager.lostPets.append((k: result.value(forKey: "beaconID") as! String, v: result.value(forKey: "emailAddress") as! String))
                            BeaconManager.lostPets2["\(String(describing: result.value(forKey: "beaconID")))"] = (result.value(forKey: "emailAddress") as! String)
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Not found")
                    }
                }
            }
        }))
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
    static func insert(beaconID: String, microchipID: String, name: String, type: String, race: String, birthDate: NSDate, ownerID: String, photo: URL) -> Bool{
        var retValue = true
        let petRecord = CKRecord(recordType: "Pet")
        petRecord["beaconID"] = beaconID as CKRecordValue
        petRecord["microchipID"] = microchipID as CKRecordValue
        petRecord["name"] = name as CKRecordValue
        petRecord["type"] = type as CKRecordValue
        petRecord["race"] = race as CKRecordValue
        petRecord["birthDate"] = birthDate as CKRecordValue
        petRecord["ownerID"] = ownerID as CKRecordValue
        if !String(describing: photo).contains("null"){
            petRecord["photo"] = CKAsset(fileURL: photo)
        }
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
    static func insert(beaconID: String, emailAddress: String, date: Date) -> Bool{
        var retValue = true;
        let missingRecord = CKRecord(recordType: "Missing")
        missingRecord["beaconID"] = beaconID as CKRecordValue
        missingRecord["emailAddress"] = emailAddress as CKRecordValue
        missingRecord["missinDate"] = date as CKRecordValue
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
    
    static func deleteMissing(recordType: String, recordName: String, deleteValue: String){
        let pred = NSPredicate(format: "\(recordName) == \"\(deleteValue)\"")
        let delq = CKQuery(recordType: recordType, predicate: pred)
        publicDB.perform(delq, inZoneWith: nil, completionHandler: ({results, error in
            if error != nil{
                print("ERROR")
            } else{
                for res in results!{
                    publicDB.delete(withRecordID: res.recordID, completionHandler: ({s, e in
                        NSLog("OK or \(String(describing: e))")}))
                }
            }
        }))
    }
    
    
    
}
