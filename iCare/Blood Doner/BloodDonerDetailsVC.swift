//
//  BloodDonerDetailsVC.swift
//  iCare
//
//  Created by Sandesh on 13/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class BloodDonerDetailsVC: UIViewController {
    
    @IBOutlet weak var lblBloodBankName: UILabel!
    @IBOutlet weak var lblBloodBankCity: UILabel!
    
    var bloodBankDetails: BloodBankModel?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 1
        let bloodBankLat = bloodBankDetails?.bloodBankLocation[0] as! CLLocationDegrees
        let bloodBankLon = bloodBankDetails?.bloodBankLocation[1] as! CLLocationDegrees

        setupView()
        
        // Step 3
        let initialLocation = CLLocation(latitude: bloodBankLat, longitude: bloodBankLon)
        self.mapView.centerToLocation(initialLocation)
        
        // Step 4
        let bloodBankLocationCenter = CLLocation(latitude: bloodBankLat, longitude: bloodBankLon)
        let region = MKCoordinateRegion(
          center: bloodBankLocationCenter.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)

        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        self.mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // Show blood bank on map
        let bloodBank = BloodBankMapData(
            title: bloodBankDetails?.bloodBankName,
          locationName: bloodBankDetails?.bloodBankCity,
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: bloodBankLat, longitude: bloodBankLon))
        self.mapView.addAnnotation(bloodBank)
    }
    
    func setupView() {
        lblBloodBankCity.text = bloodBankDetails?.bloodBankCity
        lblBloodBankName.text = bloodBankDetails?.bloodBankName
    }
}

//Step 2
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
