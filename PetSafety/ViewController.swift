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

    var pet: Pet!
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
                <<< TextRow(){ name in
                    name.title = "Name"
                    name.tag = "Name"
                    name.placeholder = "Insert pet's name"
                    name.value = pPet.name
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
                }
                <<< TextRow(){ race in
                    race.title = "Race"
                    race.tag = "Race"
                    race.placeholder = "Insert pet's race"
                    race.value = pPet.race
                }
                <<< DateRow(){ date in
                    date.title = "Date of birth"
                    date.tag = "Date of birth"
                    date.value = pPet.birthdate! as Date
                }
                <<< TextRow(){ microchip in
                    microchip.title = "Microchip ID"
                    microchip.tag = "Microchip ID"
                    microchip.placeholder = "Insert pet's microchip ID"
                    microchip.value = pPet.microchipid
                    }
                <<< TextRow(){ beacon in
                    beacon.title = "Beacon ID"
                    beacon.tag = "Beacon ID"
                    beacon.placeholder = "Insert pet's beacon ID"
                    beacon.value = pPet.beaconid
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
        
        let rowName: TextRow? = form.rowBy(tag: "Name")
        let valueName = rowName?.value
        pPet.name = valueName ?? "No name"
        
        let rowType: ActionSheetRow<String>! = form.rowBy(tag: "Type")
        let valueType = rowType?.value
        pPet.type = valueType ?? "Dog"
        
        let rowRace: TextRow? = form.rowBy(tag: "Race")
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

