//
//  BloodBankModel.swift
//  iCare
//
//  Created by Sandesh on 11/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
class BloodBankModel {
    
    var id: String?
    var bloodBankName: String?
    var bloodBankCity: String?
    var bloodBankLocation: NSArray
    
    init(id: String?, bloodBankName: String?, bloodBankCity: String?, bloodBankLocation: NSArray){
        self.id = id
        self.bloodBankName = bloodBankName
        self.bloodBankCity = bloodBankCity
        self.bloodBankLocation = bloodBankLocation

    }
}
