//
//  MyPetListCollectionViewCell.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 12/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class MyPetListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var switchMissing: UISwitch!
    @IBOutlet weak var labelRazza: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cntView: UIView!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        DispatchQueue.main.async {
            self.cntView.layer.cornerRadius = 20
            self.cntView.layer.shadowColor = UIColor.lightGray.cgColor
            self.cntView.layer.shadowOpacity = 0.1
            self.cntView.layer.shadowOffset = .zero
            self.cntView.layer.shadowPath = UIBezierPath(rect: self.cntView.bounds).cgPath
        
            
        }
    }

    @IBAction func switchMissing(_ sender: UISwitch) {
//        let pvc = MyPetListViewController()
//        pvc.switchClicked(clicked: sender.isOn)
       print("Lo switch è \(sender.isOn)")
    }
}
