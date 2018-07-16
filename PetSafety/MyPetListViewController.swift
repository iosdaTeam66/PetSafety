//
//  MyPetListViewController.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 12/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class MyPetListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var petPList: [PPet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "MyPetListCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "MyPetListID")
        
        petPList = PersistenceManager.fetchData()
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 90.0, height: collectionView.frame.size.height - 20)
        
        layout.scrollDirection = .horizontal
        layout.sideItemAlpha = 1.0
        layout.sideItemScale = 0.8
        layout.spacingMode = .fixed(spacing: 10.0)
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (petPList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPetListID", for: indexPath) as! MyPetListCollectionViewCell
        
        cell.labelNome.text = "Nome: \(petPList![indexPath.row].name ?? "error")"
        
        cell.labelRazza.text = "Razza: \(petPList![indexPath.row].race ?? "error")"
        
        //cell.image.image = UIImage(named: petPList![indexPath.row].photo)
        cell.image.image = UIImage(named: "CatMan")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
            
            //            let character = self.items[self.currentPage]
            //            self.infoLabel.text = character.name.uppercased()
            //            self.detailLabel.text = character.movie.uppercased()
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
}
