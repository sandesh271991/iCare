//
//  HomeViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GeoFire
import CoreLocation
import SVProgressHUD

class BloodCollectorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refBloodBank: DatabaseReference!
    var refAppUser: DatabaseReference!
    
    var geocoder = CLGeocoder()
    let bankAdditionQueue = DispatchQueue(label: "com.sandesh.icare", qos: .userInteractive)
    
    var bankLocation = [Double]()
    
    
    //list to store all the blood bank
    var bloodBankList = [BloodBankModel]()
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var txtBlodBankName: UITextField!
    
    @IBOutlet weak var txtBloodBankCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refBloodBank = Database.database().reference().child("bloodbank");
        refAppUser = Database.database().reference().child("appUser");
        
        addAppUser()
        
        showSpinner(onView: self.view)
        fetchBloodBanks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    func fetchBloodBanks() {
        //observing the data changes
        refBloodBank.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.bloodBankList.removeAll()
                
                //iterating through all the values
                for bloodbank in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let bloodBankObject = bloodbank.value as? [String: AnyObject]
                    let bloodBankName  = bloodBankObject?["bloodBankName"] as! String
                    let bloodBankId  = bloodBankObject?["userId"] as! String
                    let bloodBankCity = bloodBankObject?["bloodBankCity"] as! String
                    let bloodBankLocation = bloodBankObject?["bloodBankLocation"] as! NSArray
                    //creating artist object with model and fetched values
                    
                    let bloodBank = BloodBankModel(id: bloodBankId, bloodBankName: bloodBankName, bloodBankCity: bloodBankCity, bloodBankLocation: bloodBankLocation )
                    
                    //appending it to list
                    self.bloodBankList.append(bloodBank)
                }
                
                //reloading the tableview
                self.tableview.reloadData()
            }
        })
        self.removeSpinner()
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        showSpinner(onView: self.view)
        setLocation(location: txtBloodBankCity.text ?? "")
    }
    
    func addBloodBank(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refBloodBank.childByAutoId().key
        
        //creating Bank with the given values
        if  let userID = (Auth.auth().currentUser?.uid) {
            
            refBloodBank.queryOrdered(byChild: "userId").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print("exist")
                    for bloodbank in snapshot.children.allObjects as! [DataSnapshot] {
                        let bloodBankObject = bloodbank.value as? [String: AnyObject]
                        let bloodBankName  = bloodBankObject?["bloodBankName"] as! String
                        self.showAlert(title: "Blood Bank already added", message: bloodBankName)
                    }
                }
                else{
                    
                    let bloodBank = ["userId":userID,
                                     "bloodBankName": self.txtBlodBankName.text! as String,
                                     "bloodBankCity": self.txtBloodBankCity.text! as String,
                                     "bloodBankLocation": self.bankLocation
                        ] as [String : Any]
                    
                    //adding the artist inside the generated unique key
                    self.refBloodBank.child(key ?? "").setValue(bloodBank)
                    
                    //displaying message
                    print("added")
                    
                }
            })
            
        }
        self.fetchBloodBanks()
    }
    
    func addAppUser(){
        //generating a new key inside artists node
        //and also getting the generated key
        if  let userID = (Auth.auth().currentUser?.uid) {
            let key = refAppUser.childByAutoId().key
            
            //creating Bank with the given values
            
            let userInfo = ["userId":userID,
                            "userName": "sandesh",
                            "bloodBankCity": "nagpur",
                ] as [String : Any]
            
            //adding the artist inside the generated unique key
            self.refAppUser.child(key ?? "").setValue(userInfo)
            
            //displaying message
            print("user info added")
        }
    }
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
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




