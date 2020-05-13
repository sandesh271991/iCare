//
//  AddBloodDonerVC.swift
//  iCare
//
//  Created by Sandesh on 13/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
import SVProgressHUD

class AddBloodDonerVC: UIViewController {
    var refBloodBank: DatabaseReference!
    var refAppUser: DatabaseReference!
    
    var geocoder = CLGeocoder()
    var bankLocation = [Double]()
    
    @IBOutlet weak var txtBlodBankName: UITextField!
    
    @IBOutlet weak var txtBloodBankCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refBloodBank = Database.database().reference().child("bloodDoner");
        refAppUser = Database.database().reference().child("appUser");
    }
    
    
    @IBAction func btnAddBank(_ sender: Any) {
        showSpinner(onView: self.view)
        setLocation(location: txtBloodBankCity.text ?? "")
    }
    
    func setLocation(location: String){
        bankLocation.removeAll()
        var lat: CLLocationDegrees = 0
        var lon: CLLocationDegrees = 0
        geocoder.geocodeAddressString(location) { placemarks, error in
            let placemark = placemarks?.first
            lat = placemark?.location?.coordinate.latitude ?? 0
            lon = placemark?.location?.coordinate.longitude ?? 0
            self.bankLocation.append(lat)
            self.bankLocation.append(lon)
            self.addBloodBank()
        }
    }
    
    
    func addBloodBank(){
        //generating a new key inside bloodbank node
        //and also getting the generated key
        let key = refBloodBank.childByAutoId().key
        
        //creating Bank with the given values
        if  let userID = (Auth.auth().currentUser?.uid) {
            
            refBloodBank.queryOrdered(byChild: "userId").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print("exist")
                    for bloodbank in snapshot.children.allObjects as! [DataSnapshot] {
                        let bloodBankObject = bloodbank.value as? [String: AnyObject]
                        let bloodBankName  = bloodBankObject?["bloodDonerName"] as! String
                        self.showAlert(title: "Blood Doner already added", message: bloodBankName)
                        self.removeSpinner()
                    }
                }
                else{
                    let bloodBank = ["userId":userID,
                                     "bloodDonerName": self.txtBlodBankName.text! as String,
                                     "bloodDonerCity": self.txtBloodBankCity.text! as String,
                                     "bloodDonerLocation": self.bankLocation
                        ] as [String : Any]
                    
                    //adding the artist inside the generated unique key
                    self.refBloodBank.child(key ?? "").setValue(bloodBank)
                    
                    //displaying message
                    print("added")
                    self.removeSpinner()
                }
            })
            
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
