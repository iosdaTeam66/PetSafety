//
//  FoundPetViewController.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 18/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class FoundPetViewController: UITableViewController {

    var arrayPet: [Pet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayPet.count
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petFoundCell", for: indexPath) as! PetEditCell
        
        let pet = arrayPet[indexPath.row]
        cell.lblCellName.text = pet.name
        cell.lblCellRace.text = pet.race
        cell.petThumb.image = UIImage(named: pet.photo)
        return cell
        
        
        /*
        if (pet.photouuid == nil){
            image = UIImage(named: "CatMan")
        }
        else {
            let imageName = pet.photouuid // your image name here
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName!).png"
            print (imagePath)
            let imageUrl: URL = URL(fileURLWithPath: imagePath)
            guard FileManager.default.fileExists(atPath: imagePath),
                let imageData: Data = try? Data(contentsOf: imageUrl),
                let photo = UIImage(data: imageData, scale: UIScreen.main.scale) else {
                    print ("Immagine non trovata!")
                    return cell
            }
            image = photo
        }
 
        cell.petThumb.image = image
 */
 
 
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueInfoFoundPet":
            print("TODO SEGUE PER INFO PET TROVATO")
        default:
            print(#function)
        }
    }
}
