//
//  BloodDonerVC.swift
//  
//
//  Created by Sandesh on 12/05/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BloodDonerVC: UIViewController {
    
    var refBloodBank: DatabaseReference!
   // var refAppUser: DatabaseReference!

    //list to store all the blood bank
    var bloodBankList = [BloodBankModel]()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refBloodBank = Database.database().reference().child("bloodDoner");
       // refAppUser = Database.database().reference().child("appUser");
        
      //  addAppUser()
        
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
                    let bloodBankName  = bloodBankObject?["bloodDonerName"] as! String
                    let bloodBankId  = bloodBankObject?["userId"] as! String
                    let bloodBankCity = bloodBankObject?["bloodDonerCity"] as! String
                    let bloodBankLocation = bloodBankObject?["bloodDonerLocation"] as! NSArray
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
        if let addBloodDonerVC = self.storyboard?.instantiateViewController(withIdentifier:"AddBloodDonerVC") as?  AddBloodDonerVC {
            addBloodDonerVC.modalTransitionStyle   = .crossDissolve;
            addBloodDonerVC.modalPresentationStyle = .overCurrentContext
           // addBloodBankVC.delagate = self

            self.present(addBloodDonerVC, animated: true, completion: nil)
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




