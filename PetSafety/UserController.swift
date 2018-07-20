//
//  UserController.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 11/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import Eureka
import ViewRow
import ImageRow

class UserController: FormViewController {
    var pUser : PUser!
    var pUserList : [PUser]!
    let formatter = DateFormatter()
    var image: UIImageView!
    
    @IBAction func Register(_ sender: UIBarButtonItem) {
        
        if (pUser.name! == "" || pUser.surname! == "" || pUser.email! == "" || pUser.phonenumber == ""){
            let alert = UIAlertController(title: "Fields required", message: "One or more field have no data", preferredStyle: UIAlertControllerStyle.alert)
            print("if")
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            CloudManager.select(recordType: "Owners", fieldName: "emailAddress", searched: pUser.email!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if CloudManager.userDB.count > 0 {
                    var ismodified = false
                    print("Qui ci va un update!")
                    if self.pUser.name != CloudManager.userDB[3].v {
                        CloudManager.update(recordType: "Owners", recordName: "name", oldValue: CloudManager.userDB[3].v, newValue: self.pUser.name!)
                        print ("Serve un update del nome!")
                        ismodified = true
                    }
                    if self.pUser.surname != CloudManager.userDB[2].v
                    {
                        CloudManager.update(recordType: "Owners", recordName: "surname", oldValue: CloudManager.userDB[2].v, newValue: self.pUser.surname!)
                        print ("Serve un update del cognome!")
                        ismodified = true
                    }
                    if self.pUser.email != CloudManager.userDB[1].v {
                        CloudManager.update(recordType: "Owners", recordName: "emailAddress", oldValue: CloudManager.userDB[1].v, newValue: self.pUser.email!)
                        print ("Serve un update dell'email!")
                        ismodified = true
                    }
                    if self.pUser.phonenumber != CloudManager.userDB[4].v {
                        CloudManager.update(recordType: "Owners", recordName: "phoneNumber", oldValue: CloudManager.userDB[4].v, newValue: self.pUser.phonenumber!)
                        print ("Serve un update del numero!")
                        ismodified = true
                    }
                    if ismodified == true {
                        let alert = UIAlertController(title: "Infos Updated", message: "Now your user infos are up to date!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    _ = CloudManager.insert(userID: "Pippo", name: self.pUser.name!, surname: self.pUser.surname!, phoneNumber: self.pUser.phonenumber!, emailAddress: self.pUser.email!)
                    let alert = UIAlertController(title: "User Registered", message: "Now you can be contacted in case your pet has been found!", preferredStyle: UIAlertControllerStyle.alert)
                    print("if")
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("Tutto OK!")
        pUserList = PersistenceManager.fetchDataUser()
        if (pUserList.count == 0) {
            pUser = PersistenceManager.newEmptyUser()
        }
        else{
            pUser = pUserList[0]
        }
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        
        form +++ Section()
            <<< ViewRow<UIImageView>("user")
                
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = UIImageView()
                    cell.contentView.addSubview(cell.view!)
                    
                    //  Get something to display
                    if (self.pUser.photouuid == nil){
                        self.image = UIImageView(image: UIImage(named: "CatMan"))
                    }
                    else {
                        let imageName = self.pUser.photouuid // your image name here
                        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName!).png"
                        print (imagePath)
                        let imageUrl: URL = URL(fileURLWithPath: imagePath)
                        guard FileManager.default.fileExists(atPath: imagePath),
                            let imageData: Data = try? Data(contentsOf: imageUrl),
                            let photo: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) else {
                                print ("Immagine non trovata!")
                                return // No image found!
                        }
                        self.image = UIImageView(image: photo)
                    }
                    cell.view = self.image
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
                    guard let imageRow = self.form.rowBy(tag: "user") as? ViewRow<UIImageView> else {return}
                    imageRow.cell.view!.image = row.value
                    imageRow.cell.view?.frame = CGRect(x: 0, y: 20, width: 20, height: 250)
                    imageRow.cell.view?.contentMode = .scaleAspectFit
                    imageRow.cell.view!.clipsToBounds = true
                    self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let imageName = self.formatter.string(from: Date())
                    self.pUser.photouuid = imageName
                    let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
                    let imageUrl: URL = URL(fileURLWithPath: imagePath)
                    let newImage: UIImage = row.value!.fixOrientation()!// create your UIImage here
                    try? UIImagePNGRepresentation(newImage)?.write(to: imageUrl)
                    print ("Immagine Salvata!")
                    PersistenceManager.saveContext()
                }
        }
        
        form +++ Section()
            <<< ButtonRow("My Pets") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "petListSegue", onDismiss: nil)
        }
            
        form +++ Section()
            <<< SwitchRow("Disable Editing"){
               
                SwitchRow.defaultCellUpdate = { cell, row in
                    cell.switchControl?.onTintColor = #colorLiteral(red: 1, green: 0.5791348219, blue: 0, alpha: 1)
                    
                }
                
                $0.title = $0.tag
                $0.value = true
            }
            
        form +++ Section("General informations")
            <<< NameRow(){ name in
                name.title = "Name"
                name.tag = "Name"
                name.placeholder = "Required"
                name.add(rule: RuleRequired())
                name.validationOptions = .validatesOnChange
                name.disabled = Eureka.Condition.function(["Disable Editing"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Disable Editing")
                    return row.value ?? false
                })
                if(pUser.name == nil) {
                    name.value = ""    // initially selected
                } else {
                    name.value = pUser.name
                }
                name.onChange{ name in
                    self.pUser.name = name.value
                    PersistenceManager.saveContext()
                }
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< NameRow(){ surname in
                surname.title = "Surname"
                surname.tag = "Surname"
                surname.placeholder = "Required"
                surname.add(rule: RuleRequired())
                surname.validationOptions = .validatesOnChange
                surname.disabled = Eureka.Condition.function(["Disable Editing"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Disable Editing")
                    return row.value ?? false
                })
                if(pUser.name == nil) {
                    surname.value = ""    // initially selected
                } else {
                    surname.value = pUser.surname
                }
                surname.onChange{ surname in
                    self.pUser.surname = surname.value
                    PersistenceManager.saveContext()
                }
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
        }
        
        form +++ Section("Contact informations")
            <<< EmailRow(){  email in
                email.title = "Email Address"
                email.tag = "Email Address"
                email.placeholder = "Required"
                email.add(rule: RuleRequired())
                email.add(rule: RuleEmail())
                email.validationOptions = .validatesOnBlur
                email.disabled = Eureka.Condition.function(["Disable Editing"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Disable Editing")
                    return row.value ?? false
                })
                
                if(pUser.email == nil) {
                    email.value = ""    // initially selected
                } else {
                    email.value = pUser.email
                }
                email.onChange{ email in
                    self.pUser.email = email.value
                    PersistenceManager.saveContext()
                }
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< PhoneRow(){ phone in
                phone.title = "Phone Number"
                phone.tag = "Phone Number"
                phone.placeholder = "Required"
                phone.add(rule: RuleRequired())
                phone.validationOptions = .validatesOnChange
                phone.disabled = Eureka.Condition.function(["Disable Editing"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Disable Editing")
                    return row.value ?? false
                })
                if(pUser.phonenumber == nil) {
                    phone.value = ""    // initially selected
                } else {
                    phone.value = pUser.phonenumber
                }
                phone.onChange{ phone in
                    self.pUser.phonenumber = phone.value
                    PersistenceManager.saveContext()
                }
                
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let rowName: NameRow? = form.rowBy(tag: "Name")
        let valueName = rowName?.value
        pUser.name = valueName
        
        let rowSurname: NameRow? = form.rowBy(tag: "Surname")
        let valueSurname = rowSurname?.value
        pUser.surname = valueSurname
        
        let rowEmail: EmailRow? = form.rowBy(tag: "Email Address")
        let valueEmail = rowEmail?.value
        pUser.email = valueEmail
        
        let rowPhone: PhoneRow? = form.rowBy(tag: "Phone Number")
        let valuePhone = rowPhone?.value
        pUser.phonenumber = valuePhone
        
        PersistenceManager.saveContext()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
