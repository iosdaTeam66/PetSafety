//
//  MyPetListCollectionViewCell.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 12/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class MyPetListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelRazza: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cntView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        DispatchQueue.main.async {
            
            
            let color: UIColor = #colorLiteral(red: 1, green: 0.7673729658, blue: 0.3670938015, alpha: 1)
            self.cntView.backgroundColor = color
            self.cntView.layer.cornerRadius = 20
            self.cntView.layer.shadowColor = UIColor.lightGray.cgColor
            self.cntView.layer.shadowOpacity = 0
            self.cntView.layer.shadowOffset = .zero
            self.cntView.layer.shadowPath = UIBezierPath(rect: self.cntView.bounds).cgPath
        }
    }

}
