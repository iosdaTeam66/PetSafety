//
//  PersistenceManager.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 12/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import CoreData

class PersistenceManager {
    static let name = "PPet"
    static let nameUser = "PUser"
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func newEmptyPet () -> PPet {
        let context = getContext()
        let pPet = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! PPet
        let pets = fetchData()
        let index = pets.count-1
        pPet.order = Int16(index)
        pPet.type = "Dog"
        pPet.birthdate = NSDate()
        pPet.name = ""
        pPet.microchipid = ""
        pPet.race = ""
        pPet.beaconid = ""
        return pPet
    }
    
    static func newEmptyUser () -> PUser {
        let context = getContext()
        let pUser = NSEntityDescription.insertNewObject(forEntityName: nameUser, into: context) as! PUser
        
        return pUser
    }
    
    static func fetchData () -> [PPet]{
        var pets = [PPet] ()
        let context = getContext()
        let fetchRequest = NSFetchRequest<PPet>(entityName: name)
        do {
            try pets = context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Errore in fetch \(error.code)")
        }
        pets = pets.sorted{
            $0.order < $1.order
        }
        return pets
    }
    
    static func fetchDataUser () -> [PUser]{
        var user = [PUser] ()
        let context = getContext()
        let fetchRequest = NSFetchRequest<PUser>(entityName: nameUser)
        do {
            try user = context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Errore in fetch \(error.code)")
        }
        return user
    }
    
    static func saveContext() {
        let context = getContext()
        do {
            try context.save()
        } catch let error as NSError {
            print("Errore in salvataggio \(error.code)")
        }
        
    }
    
    static func deletePet(pet: PPet) {
        let context = getContext()
        context.delete(pet)
    }
    
    static func oderPet(index: Int, newIndex: Int, petArray: [PPet]) -> [PPet] {
        var tmpPetArray: [PPet] = petArray
        let sortedPet: PPet = tmpPetArray.remove(at: index)
        tmpPetArray.insert(sortedPet, at: newIndex)
        
        var i = 0
        for _ in tmpPetArray {
            tmpPetArray[i].order = Int16(i)
            //print("ordino \(tmpPetArray[i].name ?? "none") - index \(tmpPetArray[i].order)")
            i+=1
        }
        
        return tmpPetArray
    }
    
    
}
