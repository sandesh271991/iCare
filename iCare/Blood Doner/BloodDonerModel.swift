//
//  BloodDonerModel.swift
//  iCare
//
//  Created by Sandesh on 13/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
struct BloodDonerModel {
    
    var id: String?
    var bloodDonerName: String?
    var bloodDonerCity: String?
    var bloodDonerLocation: NSArray
    
    init(id: String?, bloodDonerName: String?, bloodDonerCity: String?, bloodDonerLocation: NSArray){
        self.id = id
        self.bloodDonerName = bloodDonerName
        self.bloodDonerCity = bloodDonerCity
        self.bloodDonerLocation = bloodDonerLocation
    }
}
