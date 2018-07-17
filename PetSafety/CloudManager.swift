//
//  CloudManager.swift
//  PetSafety
//
//  Created by Giaquinto Alessandro on 16/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

/*
 Sintassi utilizzata:
 
    upload(<generic>)                           Store di un oggetto completo
    storeTo<recordType>(<ID>, <param>)                        Store di un determinato valore associato ad un oggetto, riconosciuto mediante ID
    download(<recordType>, <ID>)            Obtain di un oggetto completo
    retrieveForm<recordName>(<ID>, <param>)   Retrieve di uno specifico valore associato ad un determinato ID
 
 Nota bene: Questi metodi lavorano SEMPRE sul public Database del nostro container
 Nota bene: L'handler viene gestito a parte
 Suggerimento: Usare sempre upload per l'invio, di modo che si scriva una sola volta tutti i dati
 */

class CloudManager{

    static let publicDB = CKContainer.default().publicCloudDatabase

    
    //    Upload: Public Database -> Pets list
    static func upload(beaconID: String, microchipID: String, name: String, type: String, race: String, birthDate: NSDate){
        let petID = CKRecordID(recordName: beaconID)
        let petRecord = CKRecord(recordType: "Pet", recordID: petID)
        petRecord["microchipID"] = microchipID as CKRecordValue
        petRecord["name"] = name as CKRecordValue
        petRecord["type"] = type as CKRecordValue
        petRecord["race"] = race as CKRecordValue
        petRecord["birthDate"] = birthDate as CKRecordValue
        publicDB.save(petRecord){
            (petRecord,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeMicrochipToPet(beaconID: String, microchipID: String){
        let rcd = CKRecord(recordType: "Pet", recordID: CKRecordID(recordName: beaconID))
        rcd["microchipID"] = microchipID as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeNameToPet(beaconID: String, name: String){
        let rcd = CKRecord(recordType: "Pet", recordID: CKRecordID(recordName: beaconID))
        rcd["name"] = name as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeTypeToPet(beaconID: String, type: String){
        let rcd = CKRecord(recordType: "Pet", recordID: CKRecordID(recordName: beaconID))
        rcd["type"] = type as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeraceToPet(beaconID: String, race: String){
        let rcd = CKRecord(recordType: "Pet", recordID: CKRecordID(recordName: beaconID))
        rcd["race"] = race as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeBirthDateToPet(beaconID: String, birthDate: String){
        let rcd = CKRecord(recordType: "Pet", recordID: CKRecordID(recordName: beaconID))
        rcd["birthDate"] = birthDate as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }

    //    Upload: Public Database -> Owners list
    static func upload(userID: String, name: String, surname: String, phoneNumber: String, emailAddress: String){
//        let emailID = CKRecordID(recordName: emailAddress)
        let userRecord = CKRecord(recordType: "Users"/*, recordID: emailID*/)
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
                return
            }
        }
    }
    
    static func storeUserIDToUser(emailAddress: String, userID: String){
        let rcd = CKRecord(recordType: "Users", recordID: CKRecordID(recordName: emailAddress))
        rcd["userID"] = userID as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeNameToUser(emailAddress: String, name: String){
        let rcd = CKRecord(recordType: "Users", recordID: CKRecordID(recordName: emailAddress))
        rcd["name"] = name as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }

    static func storeSurnameToUser(emailAddress: String, surname: String){
        let rcd = CKRecord(recordType: "Users", recordID: CKRecordID(recordName: emailAddress))
        rcd["surname"] = surname as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storePhoneNumberToUser(emailAddress: String, phoneNumber: String){
        let rcd = CKRecord(recordType: "Users", recordID: CKRecordID(recordName: emailAddress))
        rcd["phoneNumber"] = phoneNumber as CKRecordValue
        publicDB.save(rcd){
            (rcd,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    //    Upload: Public Database -> Missing list
    //    La chiave primaria qui è il beaconID
    static func upload(beaconID: String, emailAddress: String){
        let missingID = CKRecordID(recordName: beaconID)
        let missingRecord = CKRecord(recordType: "Missing", recordID: missingID)
        missingRecord["emailAddress"] = emailAddress as CKRecordValue
        publicDB.save(missingRecord){
            (missingRecord,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeEmailToMissing(beaconID: String, emailAddress: String){
        let missingRecord = CKRecord(recordType: "Missing", recordID: CKRecordID(recordName: beaconID))
        missingRecord["emailAddress"] = emailAddress as CKRecordValue
        publicDB.save(missingRecord){
            (missingRecord,error) in
            if error != nil{
                print("DB ERROR")
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
        publicDB.save(coordinateRecord){
            (coordinateRecord,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    
    static func storeEmailToCoordinate(beaconID: String, emailAddress: String){
        let coordRecord = CKRecord(recordType: "Coordinate", recordID: CKRecordID(recordName: beaconID))
        coordRecord["emailAddress"] = emailAddress as CKRecordValue
        publicDB.save(coordRecord){
            (coordRecord,error) in
            if error != nil{
                print("DB ERROR")
                return
            }
        }
    }
    

    static func storeLocationToCoordinate(beaconID: String, location: CLLocation){
        let crdRecord = CKRecord(recordType: "Coordinate", recordID: CKRecordID(recordName: beaconID))
        crdRecord["position"] = location as CKRecordValue
        publicDB.save(crdRecord){
            (crdRecord,error) in
            if error != nil{
                print("DBERROR")
                return
            }
        }
    }
    
    static func downloadUsers(emailAddress: String){
        let temp = CKRecord(recordType: emailAddress, recordID: CKRecordID(recordName: "Users"))
        publicDB.fetch(withRecordID: temp.recordID) { (temp, error) in
            print("DB ERROR")
        }
    }
    
    static func downloadPet(beaconID: String){
        let temp = CKRecord(recordType: beaconID, recordID: CKRecordID(recordName: "Pet"))
        publicDB.fetch(withRecordID: temp.recordID) { (temp, error) in
            print("DB ERROR")
        }
    }
    
    static func downloadMissingList(beaconID: String){
        let temp = CKRecord(recordType: beaconID, recordID: CKRecordID(recordName: "Missing"))
        publicDB.fetch(withRecordID: temp.recordID) { (temp, error) in
            print("DB ERROR")
        }
    }
    
    static func downloadCoordinate(beaconID: String){
        let temp = CKRecord(recordType: beaconID, recordID: CKRecordID(recordName: "Missing"))
        publicDB.fetch(withRecordID: temp.recordID) { (temp, error) in
            print("DB ERROR")
        }
    }
    
    static func retrieveFromUser(emailAddress: String){
        
    }
    
    static func retrieveFromPet(beaconID: String){
        
    }
    
    static func retrieveFromMissingList(beaconID: String){
        
    }
    
    static func retrieveFromCoordinate(beaconID: String){
        
    }
}
