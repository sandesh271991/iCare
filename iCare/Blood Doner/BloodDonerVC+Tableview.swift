//
//  BloodDonerVC+Tableview.swift
//  iCare
//
//  Created by Sandesh on 13/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit

extension BloodDonerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloodBankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bloodBankCell: BloodDonerCell? = tableView.dequeueReusableCell(withIdentifier: "bloodDonerCell", for: indexPath) as? BloodDonerCell
        
        if bloodBankCell == nil {
            bloodBankCell = BloodDonerCell.init(style: .default, reuseIdentifier: "bloodDonerCell")
        }
        
        //the bloodbank object
        let bloodbank: BloodBankModel
        bloodbank = bloodBankList[indexPath.row]
        
        bloodBankCell?.textLabel?.text = bloodbank.bloodBankName
        bloodBankCell?.detailTextLabel?.text = bloodbank.bloodBankCity
        
        return bloodBankCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bloodDonerDetailsVC = storyboard?.instantiateViewController(identifier: "BloodDonerDetailsVC") as! BloodDonerDetailsVC
        bloodDonerDetailsVC.bloodBankDetails = bloodBankList[indexPath.row]
        self.navigationController?.pushViewController(bloodDonerDetailsVC, animated: true)
    }
}
