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
import HGRippleRadarView

class BeaconManager: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var buttonShow: UIButton!
    @IBOutlet weak var labelFound: UILabel!
    @IBOutlet weak var labelNotification: UILabel!
    
    var locationManager: CLLocationManager!
    static var lostPets = [(k: String, v: String)]()
    static var lostPets2 = Dictionary<String,String>()
    var foundPets = [String]()
    var foundObj: [(id: String, pos: CLLocation)] = []
    var foundID = [String]()
    var currentLocation: CLLocation!
    var oldLocation: CLLocation = CLLocation(latitude: 0.0,longitude: 0.0)
    var pUser: PUser!
    static var petList = [Pet]()
    
    var bluetoothPeripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonShow.isEnabled = false
        
        let pUserList = PersistenceManager.fetchDataUser()
        if (pUserList.count == 0) {
            pUser = PersistenceManager.newEmptyUser()
        }
        else{
            pUser = pUserList[0]
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        requestLocationInUse()
        
        let options = [CBCentralManagerOptionShowPowerAlertKey:0]
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        
        let colors:[UIColor] = [#colorLiteral(red: 1, green: 0.5791348219, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.7673729658, blue: 0.3670938015, alpha: 1),#colorLiteral(red: 0.8428154588, green: 0.5546826124, blue: 0, alpha: 1)]
        radarView?.delegate = self
        radarView?.diskColor = colors[0]
        radarView?.circleOnColor = colors [0]
        radarView?.circleOffColor = .black
        
        radarView?.itemBackgroundColor = colors[0]
        
        
        // simulazione animali smarriti
        //let petLost1 = PetLost.init(lostDate: Date(), microchipID: "chip-icy", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:1", ownerID: "PippoID")
        BeaconManager.lostPets2["36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:3"] = "PippoID"
        BeaconManager.lostPets2["36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:1"] = "PippoID"
        //let petLost2 = PetLost.init(lostDate: Date(), microchipID: "chip-mint", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:2", ownerID: "PlutoID")
        //lostPets.append(petLost2)
        //let petLost3 = PetLost.init(lostDate: Date(), microchipID: "chip-blueberry", beaconUUID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:3", ownerID: "TopolinoID")
        //lostPets.append(petLost3)
        
//        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(addItem),userInfo: nil,repeats: true)
        
    
        /*
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
         
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelFound.text = "Searching missing pets in your area..."
        labelNotification.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(addItem),userInfo: nil,repeats: true)
        
        BeaconManager.lostPets.removeAll()
        CloudManager.selectMissing(recordType: "Missing")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // implementare chiusura GPS una volta chiusa la view (riapro in viewWillAppear?????)
        buttonShow.isEnabled = false
        
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        for i in 0..<items.count {
            radarView?.remove(item: items[i])
        }
        items.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        
        for i in 0..<items.count {
            radarView?.remove(item: items[i])
        }
        items.removeAll()
        

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
                //print(lostPets.keys.contains(tempStr))
                if BeaconManager.lostPets2.keys.contains(tempStr) {
                    if !foundID.makeIterator().contains(tempStr) {
                        foundID.append(tempStr)
                        foundObj.append((id: tempStr, pos: oldLocation))
                        CloudManager.selectPet(recordType: "Pet", fieldName: "beaconID", searched: tempStr)
                        print("inserisco stringa per: \(tempStr)")
                    }
                }
                i+=1
            }
            
            var k = 0
            for _ in foundObj {
                let locationObj = manager.location
                let coord = locationObj?.coordinate
                currentLocation = CLLocation(latitude: (coord?.latitude)!,longitude: (coord?.longitude)!)
                if(currentLocation.distance(from: foundObj[k].pos) > 50) { // se la nuova posizione è maggiore di 50 metri dall'ultimo rilievo
                    // inserire QUI le coordinate nella tabella ONLINE
                    _ = CloudManager.insert(beaconID: foundID[k], emailAddress: pUser.email!, location: currentLocation, findingDate: Date())
                    print("inserisco DB per: \(foundID[k])")
                    foundObj[k].pos = currentLocation
                }
                k+=1
            }
            
            
            buttonShow.isEnabled = true
            labelFound.text = "Found lost pets near you!!!"
            
            labelNotification.isHidden = false
            
            
            /*
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
             */
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        
        
        UIView.animate(withDuration: 0.8) {
            /*
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
             */
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueFoundPet":
            
//            TODO INFO PER IL SEGUE
            
            //let p: Pet = Pet(name: "name", race: "race", type: "type", photo: "CatMan", birthDate: Date(), microchipID: "", beaconUUID: "")
            //let p2: Pet = Pet(name: "name", race: "race", type: "type", photo: "radar", birthDate: Date(), microchipID: "", beaconUUID: "")
            
            //var petlist: [Pet] = []
            //petlist.append(p)
            //petlist.append(p2)
            //petlist.append(p)
            
            let dstView = segue.destination as! FoundPetViewController
            dstView.arrayPet = BeaconManager.petList
            
            for _ in 0..<foundID.count {
                //                    chiamate al server una per id
            }
            
            
        default: print(#function)
        }
    }
    
    
//    FUNZIONI PER IL RADAR
    
    var timer: Timer?
    var items = [Item]()
    let maxItems: Int = 10
    
    var radarView: RadarView? {
        return view as? RadarView
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func addItem() {
        if items.count < maxItems {
            let item = Item(uniqueKey: "", value:"")
            items.append(item)
            radarView?.add(item: item)
        } else {
            radarView?.remove(item: items.first!)
            items.remove(at: 0)
        }
    }
}

extension BeaconManager: RadarViewDelegate,RadarViewDataSource {
    func radarView(radarView: RadarView, didSelect item: Item) {
        print(item.uniqueKey)
    }
    
    func radarView(radarView: RadarView, didDeselect item: Item) {}
    
    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item) {}
    
    func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView {
        let myCustomItemView = UIView(frame: CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height))
        return myCustomItemView
    }
}
