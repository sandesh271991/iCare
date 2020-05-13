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

class BloodCollectorVC: UIViewController {
    
    var refBloodBank: DatabaseReference!
    var refAppUser: DatabaseReference!

    //list to store all the blood bank
    var bloodBankList = [BloodBankModel]()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refBloodBank = Database.database().reference().child("bloodbank");
        refAppUser = Database.database().reference().child("appUser");
        
        addAppUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         fetchBloodBanks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchBloodBanks() {
        //observing the data changes
        showSpinner(onView: self.view)

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
//        showSpinner(onView: self.view)
//        setLocation(location: txtBloodBankCity.text ?? "")
    }
    
    
    @IBAction func btnAddBloodBank(_ sender: Any) {
        if let addBloodBankVC = self.storyboard?.instantiateViewController(withIdentifier:"AddBloodBankVC") as?  AddBloodBankVC {
            addBloodBankVC.modalTransitionStyle   = .crossDissolve;
            addBloodBankVC.modalPresentationStyle = .overCurrentContext
           // addBloodBankVC.delagate = self

            self.present(addBloodBankVC, animated: true, completion: nil)
        }
    }
    
   
    // Can create diff screen to add userinfo
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
}




