//
//  MapController.swift
//  PetSafety
//
//  Created by Marciano Filippo on 16/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//

import UIKit

// librerie importate
import MapKit
import CoreLocation

class MapController: UIViewController {
    
    //array di prova
    var nomeArr: [String] = []
    var dataArr: [String] = []
    var viaArr: [String] = []
    var cittaArr: [String] = []
    var coord: [(lat:Double, lag: Double)] = []
    var points: [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    //outlet
  
    @IBOutlet weak var BigMap: MKMapView!
    
    //aggiungo label

    @IBOutlet weak var dataUlt: UILabel!
    @IBOutlet weak var addressUlt: UILabel!
    @IBOutlet weak var viewUlt: UIView!
    
    //variabile di passaggio da segue
    
    var valueCane : StoreMap = StoreMap()
    
    
    
    //azione bottone creato da codice
    @IBAction func showDetailButtonPressed(sender: AnyObject){
        let button = sender as! UIButton
        let index = button.tag
        
        //per passaggio dati
        let  latToShow = self.coord[index].lat
        let  longToShow = self.coord[index].lag
        
        let co = CLLocation(latitude: latToShow, longitude: longToShow)
        let CLLCoordType = CLLocationCoordinate2D(latitude: co.coordinate.latitude, longitude: co.coordinate.longitude)
        self.notificaInfo(citta: cittaArr[index], via: viaArr[index], coordinate: CLLCoordType, nome: nomeArr[index], data: dataArr[index])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //aggiunto funzione
        self.prepareData()
        self.enableLocationService()
        
        //bordi rotondi view
        viewUlt.layer.borderWidth = 1
        viewUlt.layer.borderColor = UIColor.darkGray.cgColor
        viewUlt.layer.cornerRadius = 15
        viewUlt.clipsToBounds = true
        
        self.locationManager.desiredAccuracy  = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.BigMap.showsUserLocation = true
        
        self.aggiungiAnnotation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        self.prepareData()
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //metodo prepara dati che andra modificato per prenderli dal DB
    func prepareData() {
        
        self.nomeArr = valueCane.nomeArr
        self.dataArr = valueCane.dataArr
        self.cittaArr = valueCane.cittaArr
        self.viaArr = valueCane.viaArr
        self.coord = valueCane.coord
    }
    
    
    //aggiunge le annotiation da modificare per il DB
    func aggiungiAnnotation(){
        
        
        let ultimo = valueCane.cittaArr.count - 1
        var iniziale = 0
        dataUlt.text = " "
        addressUlt.text = "non ci sono posizioni"
        
        if(valueCane.cittaArr.count > 10){
            iniziale = valueCane.cittaArr.count - 10
        }else{
            iniziale = 0
        }
        
        if(valueCane.cittaArr.isEmpty == false ){
            for i in iniziale...ultimo{
                let cittaAnnotation = MKAnnotationView()
                
                let  latToShow = self.coord[i].lat
                let  longToShow = self.coord[i].lag
                
                let co = CLLocation(latitude: latToShow, longitude: longToShow)
                let CLLCoordType = CLLocationCoordinate2D(latitude: co.coordinate.latitude, longitude: co.coordinate.longitude)
                
                
                let nameToShow = self.nomeArr[i]
                let dataToShow = self.dataArr[i]
                let titleToShow = self.cittaArr[i]
                let subtitleToShow = self.viaArr[i]
                
                cittaAnnotation.annotation = PetAnnotation(name: nameToShow, title: titleToShow, subtitle: subtitleToShow, indice: i, coordinate: CLLCoordType,data: dataToShow)
                
                //aggiunge point
                points.append(CLLCoordType)
                
                //fa pallino verde vicino all ultimo
                if(i == ultimo){
                    //scrive nei label
                    dataUlt.text = dataToShow
                    addressUlt.text = "\(titleToShow), \(subtitleToShow)"
                    
                    //aggiunge poligono
                    BigMap.addOverlays([MKPolyline(coordinates: &points, count: points.count)])
                    
                    //aggiunge cerchio all'ultimo
                    BigMap.addOverlays([MKCircle(center: CLLCoordType, radius: CLLocationDistance(integerLiteral: 10))])
                    
                    
                }
                
                //aggiunge alla mappa
                if let ann = cittaAnnotation.annotation{
                    
                    self.BigMap.addAnnotation(ann)
                    
                    print("Annotation aggiunta")
                }
                
            }
        }
        
    }
    
    //notifica al click piu informazioni
    func notificaInfo(citta: String,via: String,coordinate:CLLocationCoordinate2D,nome: String,data: String){
        let alert = UIAlertController(title: " Avvistamento\n\n", message: " Città: \(citta)\n\n Via: \(via)\n\n Coord.latitudine: \(coordinate.latitude) \n\n Coord.longitudine: \(coordinate.longitude) \n\n Data: \(data) \n\n Da: \(nome) \n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//per gestiere locazione
extension MapController: CLLocationManagerDelegate{
    
    //da la nostra posizione
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        //settando la region impostaiamo la grandezza della mappa
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.BigMap.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    //gestisce caso di errore
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errore: " + error.localizedDescription)
    }
    
    //chiede all utente l autorizzazione di tracciarlo
    func enableLocationService(){
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    //modifica punti
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle{
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.gray
            circleRenderer.alpha = 0.8
            circleRenderer.strokeColor = UIColor.green
            circleRenderer.lineWidth = 15
            return circleRenderer
        }
        
        if let overlay = overlay as? MKPolyline{
            let poligonView = MKPolylineRenderer(overlay: overlay)
            poligonView.fillColor = UIColor.darkGray
            poligonView.alpha = 0.8
            poligonView.strokeColor = UIColor.darkGray
            poligonView.lineWidth = 2
            poligonView.lineDashPattern = [2,5];
            return poligonView
        }
        
        return MKOverlayRenderer()
    }
    
    
    
}


//permette di gestire tutta la parte della mappa
extension MapController: MKMapViewDelegate{
    
    //viene chiamato quando il sistema deve aggiungere un annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) ->MKAnnotationView? {
        
        let identifier = "Pet"
        
        if(annotation.isKind(of: MKUserLocation.self)){
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled =  true
            annotationView.canShowCallout = true
            return annotationView
        }else{
            if let petAnn = annotation as? PetAnnotation {
                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.isEnabled =  true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                btn.addTarget(self, action: #selector(showDetailButtonPressed), for: .touchUpInside)
                btn.tag = petAnn.indice
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
            }
        }
        return nil
    }
}
