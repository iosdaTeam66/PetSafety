//
//  ViewController.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 10/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import ViewRow

class ViewController: FormViewController {

    var pPet: PPet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< ViewRow<UIImageView>("ciao")
                
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = UIImageView()
                    cell.contentView.addSubview(cell.view!)
                    
                    //  Get something to display
                    let image = UIImageView(image: UIImage(named: "CatMan"))
                    cell.view = image
                    cell.view?.frame = CGRect(x: 0, y: 20, width: 20, height: 250)
                    cell.view?.contentMode = .scaleAspectFit
                    cell.view!.clipsToBounds = true
                }
            
        form +++ Section()
            <<< ImageRow() { row in
                row.title = "Edit photo"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                row.onChange { photo in
                    guard let imageRow = self.form.rowBy(tag: "ciao") as? ViewRow<UIImageView> else {return}
                    imageRow.cell.view!.image = row.value
                    }
                }
        
        
            form +++ Section("Informations")
                <<< NameRow(){ name in
                    name.title = "Name"
                    name.tag = "Name"
                    name.placeholder = "Insert pet's name"
                    if(pPet.name == nil) {
                        name.value = ""    // initially selected
                    } else {
                        name.value = pPet.name
                    }
                    name.onChange{ name in
                        self.pPet.name = name.value
                        PersistenceManager.saveContext()
                    }
                }
                <<< ActionSheetRow<String>() { type in
                    type.title = "Type"
                    type.tag = "Type"
                    type.selectorTitle = "Peek an pet"
                    type.options = ["Dog","Cat","Rabbit"]
                   if(pPet.type == nil) {
                       type.value = "Dog"    // initially selected
                   } else {
                       type.value = pPet.type
                   }
                    type.onChange{ type in
                        self.pPet.type = type.value
                        PersistenceManager.saveContext()
                    }
                }
                <<< NameRow(){ race in
                    race.title = "Race"
                    race.tag = "Race"
                    race.placeholder = "Insert pet's race"
                    if(pPet.race == nil) {
                        race.value = ""    // initially selected
                    } else {
                        race.value = pPet.race
                    }
                    race.onChange{ race in
                        self.pPet.race = race.value
                        PersistenceManager.saveContext()
                    }
                }
                <<< DateRow(){ date in
                    date.title = "Date of birth"
                    date.tag = "Date of birth"
                    if(pPet.birthdate == nil) {
                        date.value = NSDate() as Date  // initially selected
                    } else {
                        date.value = pPet.birthdate! as Date
                    }
                    date.onChange{ date in
                        self.pPet.birthdate = date.value! as NSDate
                        PersistenceManager.saveContext()
                    }
                }
                <<< TextRow(){ microchip in
                    microchip.title = "Microchip ID"
                    microchip.tag = "Microchip ID"
                    microchip.placeholder = "Insert pet's microchip ID"
                    if(pPet.microchipid == nil) {
                        microchip.value = ""    // initially selected
                    } else {
                        microchip.value = pPet.microchipid
                    }
                    microchip.onChange{ microchip in
                        self.pPet.microchipid = microchip.value
                        PersistenceManager.saveContext()
                    }
                }
                
                <<< TextRow(){ beacon in
                    beacon.title = "Beacon ID"
                    beacon.tag = "Beacon ID"
                    beacon.placeholder = "Insert pet's beacon ID"
                    if(pPet.beaconid == nil) {
                        beacon.value = ""    // initially selected
                    } else {
                        beacon.value = pPet.beaconid
                    }
                    beacon.onChange{ beacon in
                        self.pPet.beaconid = beacon.value
                        PersistenceManager.saveContext()
                    }
                }
        
                
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let rowName: NameRow? = form.rowBy(tag: "Name")
        let valueName = rowName?.value
        pPet.name = valueName ?? "No name"
        
        let rowType: ActionSheetRow<String>! = form.rowBy(tag: "Type")
        let valueType = rowType?.value
        pPet.type = valueType ?? "Dog"
        
        let rowRace: NameRow? = form.rowBy(tag: "Race")
        let valueRace = rowRace?.value
        pPet.race = valueRace ?? ""
        
        let rowBirthDate: DateRow? = form.rowBy(tag: "Date of birth")
        let valueBirthDate = rowBirthDate?.value
        pPet.birthdate = valueBirthDate! as NSDate
        
        let rowMicrochipID: TextRow? = form.rowBy(tag: "Microchip ID")
        let valueMicrochipID = rowMicrochipID?.value
        pPet.microchipid = valueMicrochipID ?? ""
        
        let rowBeaconID: TextRow? = form.rowBy(tag: "Beacon ID")
        let valueBeaconID = rowBeaconID?.value
        pPet.beaconid = valueBeaconID ?? ""
        
        PersistenceManager.saveContext()
    }
    



}

