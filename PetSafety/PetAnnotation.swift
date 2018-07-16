//
//  PetAnnotation.swift
//  MappaEs
//
//  Created by Siani Giuseppe on 12/07/18.
//  Copyright © 2018 Siani Giuseppe. All rights reserved.
//

import UIKit

//import aggiunti
import MapKit

//aggiunto estenzione
class PetAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let name : String   //nome persona che l'ha trovato
    let title: String?      //citta
    let subtitle: String?   //via
    let indice : Int
    let data: String? //data ritrovamento
    
    init(name: String, title: String, subtitle: String, indice: Int, coordinate: CLLocationCoordinate2D,data: String) {
        self.name = name
        self.title = title
        self.subtitle = subtitle
        self.indice = indice
        self.coordinate = coordinate
        self.data = data
        
        super.init()
    }
    

}
