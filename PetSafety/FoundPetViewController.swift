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

        print("PET FOUND VIEW CONTROLLER")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "petFoundCell", for: indexPath) as! PetFoundCell
        
        let pet = arrayPet[indexPath.row]
        cell.labelNomeRazza.text = "NAME: \(pet.name)"
        
        cell.labelContatto.text = "OWNER INFO: \(pet.microchipID)"
        cell.labelNomePadrone.text = "RACE: \(pet.race)"
        cell.imagePet.image = UIImage(named: "CatMan")

        return cell
    }
}
