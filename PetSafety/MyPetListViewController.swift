//
//  MyPetListViewController.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 12/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit
import CloudKit

class MyPetListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var labelNoPet: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var switchMissing: UISwitch!
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var imageNoPet: UIImageView!
    

    var pUser: [PUser]!
    var petPList: [PPet]?
    static var positionDB = [(pos: CLLocation, email: String, date: String, index: Int)]()
    var items = [(pos: CLLocation, email: String, date: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "MyPetListCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "MyPetListID")
        
        petPList = PersistenceManager.fetchData()
        pUser = PersistenceManager.fetchDataUser()
        
        let reqNum = petPList?.count ?? 0
        var reqNum2 = 0
        if(reqNum != 0) {
            reqNum2 = reqNum-1
        }
        for i in 0...reqNum2 {
            if((petPList?.count)! > 0) {
                let myPet = petPList![i]
                CloudManager.selectPosition(rcdTp: "Coordinate", fieldName: "beaconID", searched: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:\(myPet.beaconid!)", index: i)
            }
        }
        
        imageNoPet.image = UIImage(named: "sleeping-dog")
        
        if(petPList?.count == 0){
            labelNoPet.isHidden = false
            switchMissing.isHidden = true
            buttonMap.isHidden = true
            
        } else {
            labelNoPet.isHidden = true
            switchMissing.isHidden = false
            buttonMap.isHidden = false
            imageNoPet.isHidden = true
        }
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 70.0, height: collectionView.frame.size.height - 50)

        layout.scrollDirection = .horizontal
        layout.sideItemAlpha = 1.0
        layout.sideItemScale = 0.8
        layout.spacingMode = .fixed(spacing: 5)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petPList = PersistenceManager.fetchData()
        collectionView.reloadData()
        
        if(petPList?.count == 0){
            labelNoPet.isHidden = false
            switchMissing.isHidden = true
            buttonMap.isHidden = true
            imageNoPet.isHidden = false
        } else {
            labelNoPet.isHidden = true
            switchMissing.isHidden = false
            buttonMap.isHidden = false
            imageNoPet.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        PersistenceManager.saveContext()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = (petPList?.count)!
        return (petPList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPetListID", for: indexPath) as! MyPetListCollectionViewCell
        
        cell.labelNome.text = "Name: \(petPList![indexPath.row].name ?? "error")"
        
        cell.labelRazza.text = "Race: \(petPList![indexPath.row].race ?? "error")"
        
        //cell.image.image = UIImage(named: petPList![indexPath.row].photo)
        if (petPList![indexPath.row].photouuid == nil){
            cell.image.image = UIImage(named: "CatMan")
        }
        else {
            let imageName = petPList![indexPath.row].photouuid // your image name here
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName!).png"
            print (imagePath)
            let imageUrl: URL = URL(fileURLWithPath: imagePath)
            guard FileManager.default.fileExists(atPath: imagePath),
                let imageData: Data = try? Data(contentsOf: imageUrl),
                let photo: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) else {
                    print ("Immagine non trovata!")
                    return  cell// No image found!
            }
            cell.image.image = photo
        }
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
        
    fileprivate var currentPage: Int = 0 {
        didSet {
//            print("page at centre = \(currentPage)")
            pageControl.currentPage = currentPage
//   aspetto campo in ppet         switchMissing.isOn = petPList![currentPage].
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    @IBAction func clickSwitchMissing(_ sender: UISwitch) {
        
        let beaconString = petPList![pageControl.currentPage].beaconid
        let mail = pUser[0].email
        let date = Date()
        
        if sender.isOn {
                // azione quando si attiva
            let bool = CloudManager.insert(beaconID: "36996E77-5789-6AA5-DF5E-25FB5D92B34B:1:\(beaconString!)", emailAddress: mail!, date: date)
            print("bool switch missing \(bool)")
            
        } else {
                //   azione quando si spegne
            CloudManager.deleteMissing(recordType: "Missing", recordName: "beaconID", deleteValue: beaconString!)
            
        }
    }
    
    @IBAction func buttonMap(_ sender: Any) {
        var nomeArr: [String] = []
        var dataArr: [String] = []
        var coord: [(lat:Double, lag: Double)] = []

        
        var i = 0
        for _ in MyPetListViewController.positionDB {
            self.items.removeAll()

            if(MyPetListViewController.positionDB[i].index == self.pageControl.currentPage) {

                self.items.append((pos: MyPetListViewController.positionDB[i].pos, email: MyPetListViewController.positionDB[i].email, date: MyPetListViewController.positionDB[i].date))
                nomeArr.append(" ")
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                dateformatter.dateStyle = DateFormatter.Style.medium
                dataArr.append(MyPetListViewController.positionDB[i].date)
                coord.append((MyPetListViewController.positionDB[i].pos.coordinate.latitude, MyPetListViewController.positionDB[i].pos.coordinate.longitude))
            }
            i+=1
        }
        
        //arre auto generati da coordinate
        let cittaArr: [String] = [String] ()
        let viaArr: [String] = [String] ()
        
        //oggetto da passare
        let cane1: StoreMap = StoreMap(nomeArr: nomeArr, dataArr: dataArr, viaArr: viaArr, cittaArr: cittaArr, coord: coord)
        self.performSegue(withIdentifier: "showMap", sender: cane1)
        
    }
    
    //passaggio parametri
    //si fa l overide
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap"{
            let destVC = segue.destination as! MapController
            destVC.valueCane = sender as! StoreMap
        }
    }
}
