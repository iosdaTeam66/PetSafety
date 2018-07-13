//
//  PetEditCell.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 10/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class PetEditCell: UITableViewCell {

    @IBOutlet weak var lblCellName: UILabel!
    @IBOutlet weak var lblCellRace: UILabel!
    @IBOutlet weak var petThumb: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
