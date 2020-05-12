//
//  ViewController+Extension.swift
//  iCare
//
//  Created by Sandesh on 11/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit

 var vSpinner : UIView?

 extension UIViewController {
     func showSpinner(onView : UIView) {
         let spinnerView = UIView.init(frame: onView.bounds)
         spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
         let ai = UIActivityIndicatorView.init(style: .whiteLarge)
         ai.startAnimating()
         ai.center = spinnerView.center
         
         DispatchQueue.main.async {
             spinnerView.addSubview(ai)
             onView.addSubview(spinnerView)
         }
         
         vSpinner = spinnerView
     }
     
     func removeSpinner() {
         DispatchQueue.main.async {
             vSpinner?.removeFromSuperview()
             vSpinner = nil
         }
     }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
 }

