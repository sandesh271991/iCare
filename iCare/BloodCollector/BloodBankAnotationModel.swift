//
//  BloodBankAnotationModel.swift
//  iCare
//
//  Created by Sandesh on 12/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import MapKit

class BloodBankMapData: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
