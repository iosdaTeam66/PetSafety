//
// BeaconManager.swift
// PetSafety
//
// Created by Marciano Filippo on 13/07/18.
// Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Eureka
import ViewRow
import ImageRow

class BeaconManager: FormViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    var lostPets = Dictionary<String, String>()
    var foundPets = [String]()
    var foundID = [String]()
    var currentLocation: CLLocation!
    var oldLocation: CLLocation = CLLocation(latitude: 0.0,longitude: 0.0)
    var pUser: PUser!
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    
    @IBOutlet weak var proximityText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pUserList = PersistenceManager.fetchDataUser()
        if (pUserList.count == 0) {
            pUser = PersistenceManager.newEmptyUser()
        }
        else{
            pUser = pUserList[0]
        }
        
        // sfondo bianco
        let whiteColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        view.backgroundColor = whiteColor
        // celle senza bordi
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        // immagine radar
        form +++ Section()
            <<< ViewRow<UIImageView>("radar")
                
                .cellSetup { (cell, row) in
                    // Construct the view for the cell
                    cell.view = UIImageView()
                    cell.contentView.addSubview(cell.view!)
                    cell.backgroundColor = nil // sfondo trasparente
                    
                    // Get something to display
                    let image = UIImageView(image: UIImage(named: "radar"))
                    cell.view = image
                    cell.view?.frame = CGRect(x: 0, y: 40, width: 20, height: 200)
                    cell.view?.contentMode = .scaleAspectFit
                    cell.view!.clipsToBounds = true
            }
            
            <<< LabelRow() {
                $0.title = "Searching missing pets in your area..."
                $0.cellStyle = .default
                }
                .cellUpdate({ (cell, row) in
                    cell.backgroundColor = nil
                    cell.contentView.backgroundColor = nil
                    cell.textLabel?.textColor = .black
                    cell.textLabel?.textAlignment = .center
                })
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        requestLocationInUse()
        
        let options = [CBCentralManagerOptionShowPowerAlertKey:0]
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        
        // simulazione animali smarriti
        //let petLost1 = PetLost.init(lostDate: Date(), microchipID: "chip-icy", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:1", ownerID: "PippoID")
        lostPets["36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:3"] = "PippoID"
        lostPets["36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:1"] = "PippoID"
        //let petLost2 = PetLost.init(lostDate: Date(), microchipID: "chip-mint", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:2", ownerID: "PlutoID")
        //lostPets.append(petLost2)
        //let petLost3 = PetLost.init(lostDate: Date(), microchipID: "chip-blueberry", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:3", ownerID: "TopolinoID")
        //lostPets.append(petLost3)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // implementare chiusura GPS una volta chiusa la view (riapro in viewWillAppear?????)
    }
    
    func requestLocationInUse() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            self.openAlertToSettings(title: "Location in use disabled",
                                     description: "To enable the location change it in Settings.", bluetooth: true)
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            break
        }
    }
    
    
    private func openAlertToSettings(title: String, description: String, bluetooth: Bool) {
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if bluetooth {
                if let url = URL(string:"App-Prefs:root=Bluetooth") {
                    UIApplication.shared.open(url)
                }
            } else {
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Location: Not determined")
            break
        case .restricted:
            print("Location: Restricted")
            self.openAlertToSettings(title: "Location in use disabled",
                                     description: "To enable the location change it in Settings.", bluetooth: false)
            break
        case .denied:
            print("Location: Denied")
            self.openAlertToSettings(title: "Location in use disabled",
                                     description: "To enable the location change it in Settings.", bluetooth: false)
            break
        case .authorizedWhenInUse:
            print("Location: Authorized when in use")
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
            break
        case .authorizedAlways:
            print("Location: Authorized always")
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
            break
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case CBManagerState.poweredOn:
            print("Bluetooth Status: Turned On")
            
        case CBManagerState.poweredOff:
            print("Bluetooth Status: Turned Off")
            self.openAlertToSettings(title: "Bluetooth is disabled",
                                     description: "To enable the bluethoot change it in Settings.", bluetooth: true)
            
        case CBManagerState.resetting:
            print("Bluetooth Status: Resetting")
            
        case CBManagerState.unauthorized:
            print("Bluetooth Status: Not Authorized")
            
        case CBManagerState.unsupported:
            print("Bluetooth Status: Not Supported")
            
        default:
            print("Bluetooth Status: Unknown")
        }
        
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "36996E77-5789-6AA5-DF5E-25FB5D92B34B")
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "iOSBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
            
            // implementazione pet trovato
            var tempStr: String = ""
            
            var i = 0
            for _ in beacons {
                tempStr="\(beacons[i].proximityUUID):\(beacons[i].major):\(beacons[i].minor)"
                print(lostPets.keys.contains(tempStr))
                if lostPets.keys.contains(tempStr) {
                    if !foundID.makeIterator().contains(tempStr) {
                        foundID.append(tempStr)
                    }
                }
                i+=1
            }
            
            let locationObj = manager.location
            let coord = locationObj?.coordinate
            currentLocation = CLLocation(latitude: (coord?.latitude)!,longitude: (coord?.longitude)!)
            if(currentLocation.distance(from: oldLocation) > 50) { // se la nuova posizione è maggiore di 50 metri dall'ultimo rilievo
                // inserire QUI le coordinate nella tabella ONLINE
                oldLocation = currentLocation
            }
            
            let alert = UIAlertController(title: "iBeacons Detected", message: "Found lost pets near you\n\nA notification with the location has just been sent to the owners", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Show", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    let viewControllerPetsFound = self.storyboard?.instantiateViewController(withIdentifier: "PetsFound")
                    self.present(viewControllerPetsFound!, animated: true, completion: nil)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        self.proximityText.text = "\(distance.rawValue)";
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
            }
        }
    }
    
}
