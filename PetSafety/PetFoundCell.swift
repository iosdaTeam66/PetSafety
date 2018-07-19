//
//  PetFoundCell.swift
//  PetSafety
//
//  Created by De Cristofaro Paolo on 19/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class PetFoundCell: UITableViewCell {

    @IBOutlet weak var imagePet: UIImageView!
    @IBOutlet weak var labelNomePadrone: UILabel!
    @IBOutlet weak var labelNomeRazza: UILabel!
    @IBOutlet weak var labelContatto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
