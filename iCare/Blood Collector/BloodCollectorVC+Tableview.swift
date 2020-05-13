//
//  BloodCollectorVC+Tableview.swift
//  iCare
//
//  Created by Sandesh on 12/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit

extension BloodCollectorVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloodBankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bloodBankCell: BloodBankCell? = tableView.dequeueReusableCell(withIdentifier: "bloodBankCell", for: indexPath) as? BloodBankCell
        
        if bloodBankCell == nil {
            bloodBankCell = BloodBankCell.init(style: .default, reuseIdentifier: "bloodBankCell")
        }
        
        //the bloodbank object
        let bloodbank: BloodBankModel
        bloodbank = bloodBankList[indexPath.row]
        
        bloodBankCell?.textLabel?.text = bloodbank.bloodBankName
        bloodBankCell?.detailTextLabel?.text = bloodbank.bloodBankCity
        
        return bloodBankCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bloodBankDetailsVC = storyboard?.instantiateViewController(identifier: "BloodBankDetailsVC") as! BloodBankDetailsVC
        bloodBankDetailsVC.bloodBankDetails = bloodBankList[indexPath.row]
        self.navigationController?.pushViewController(bloodBankDetailsVC, animated: true)
    }
}
