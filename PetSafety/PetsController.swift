//
//  PetsController.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 10/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import Eureka

class PetsController: UITableViewController {
    
    var petPList: [PPet]!
    var imageStore: ImageStore!
    var image: UIImage!
    
    @IBAction func addNewPet(_ sender: UIBarButtonItem) {
        //petList.addEmptyPet()
        //let index = IndexPath(row: petList.petArray.count-1, section: 0)
        //tableView.insertRows(at: [index], with: .automatic)
        
        performSegue(withIdentifier: "newPet", sender: sender)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

          petPList = PersistenceManager.fetchData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        PersistenceManager.saveContext()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return petList.petArray.count
        return petPList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petEditCell", for: indexPath) as! PetEditCell

        let pet = petPList[indexPath.row]
        cell.lblCellName.text = pet.name
        cell.lblCellRace.text = pet.race
        

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
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedPet = petPList.remove(at: indexPath.row)
            PersistenceManager.deletePet(pet: removedPet)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        petList.sortPet(index: fromIndexPath.row, newIndex: to.row)
        petPList = PersistenceManager.oderPet(index: fromIndexPath.row, newIndex: to.row, petArray: petPList)
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "showPet"?:
            
            if let currentIndex = tableView.indexPathForSelectedRow?.row {
                
                let currentPet = petPList[currentIndex]
                
                let dstView = segue.destination as! ViewController
                
                dstView.pPet = currentPet
                
            }
        
        case "newPet"?:
            

            let newPet = PersistenceManager.newEmptyPet()
            
            petPList.append(newPet)

            let currentPet = petPList[petPList.count-1]
            
            let dstView = segue.destination as! ViewController
            
            dstView.pPet = currentPet
            
        default: print(#function)
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
