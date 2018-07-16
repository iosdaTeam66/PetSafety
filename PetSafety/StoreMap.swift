//
//  StoreMap.swift
//  PetSafety
//
//  Created by Marciano Filippo on 16/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

class StoreMap: NSObject {
    //variabili
    var nomeArr: [String] = []
    var dataArr: [String] = []
    var viaArr: [String] = []
    var cittaArr: [String] = []
    var coord: [(lat:Double, lag: Double)] = []
    
    init(nomeArr: [String], dataArr: [String],viaArr: [String], cittaArr: [String], coord: [(lat:Double, lag: Double)]){
        self.nomeArr = nomeArr
        self.dataArr = dataArr
        self.viaArr = viaArr
        self.cittaArr = cittaArr
        self.coord = coord
    }
    
    override init() {
    }
}
