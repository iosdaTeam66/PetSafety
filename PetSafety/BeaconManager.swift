//
//  BeaconManager.swift
//  PetSafety
//
//  Created by Marciano Filippo on 13/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Eureka
import ViewRow
import ImageRow

class BeaconManager: FormViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    var lostPets = [PetLost]()
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    
    @IBOutlet weak var proximityText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sfondo bianco
        let whiteColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        view.backgroundColor = whiteColor
        // celle senza bordi
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        // immagine radar
        form +++ Section()
            <<< ViewRow<UIImageView>("radar")
                
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = UIImageView()
                    cell.contentView.addSubview(cell.view!)
                    cell.backgroundColor = nil  // sfondo trasparente
                    
                    //  Get something to display
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
        let petLost1 = PetLost.init(lostDate: Date(), microchipID: "chip-icy", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B", ownerID: "PippoID")
        lostPets.append(petLost1)
        
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
        //let uuid = UUID(uuidString: "36996E77-5789-6AA5-DF5E-25FB5D92B34B")!
        
        let uuid = UUID(uuidString: lostPets[0].beaconUUID)
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 1, minor: 1, identifier: "iOSBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
            
            // implementazione pet trovato
            //let lp1String: String = beacons[0].proximityUUID.uuidString
            let alert = UIAlertController(title: "Beacon Detected", message: "Found \(beacons.count) lost pet near you\n\nA notification with the location has just been sent to the owners", preferredStyle: UIAlertControllerStyle.alert)
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
