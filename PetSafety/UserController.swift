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
        
        form +++ Section()
            <<< ViewRow<UIImageView>("user")
                
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
                    guard let imageRow = self.form.rowBy(tag: "user") as? ViewRow<UIImageView> else {return}
                    imageRow.cell.view!.image = row.value
                }
        }
        
        form +++ Section()
            <<< ButtonRow("My Pets") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "petListSegue", onDismiss: nil)
        }
        form +++ Section("General informations")
            
            <<< NameRow(){ name in
                name.title = "Name"
                name.tag = "Name"
                name.placeholder = "Insert your name"
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
            <<< NameRow(){ surname in
                surname.title = "Surname"
                surname.tag = "Surname"
                surname.placeholder = "Insert your surname"
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
        
        form +++ Section("Contact informations")
            <<< EmailRow(){  email in
                email.title = "Email Address"
                email.tag = "Email Address"
                email.placeholder = "Insert your email address"
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
            <<< PhoneRow(){ phone in
                phone.title = "Phone Number"
                phone.tag = "Phone Number"
                phone.placeholder = "Insert your phone number"
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
