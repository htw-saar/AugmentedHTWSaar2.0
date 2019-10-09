//
//  ShowAlterMessage.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christian Herz on 28.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//
//  This class is for showing Alerts
//

//import Foundation
import UIKit

class ShowAlertMessage:  UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func displayAlertMessageFehlendeFelder(userMessage: String){
        let alert = UIAlertController(title: "Sie haben nicht alle Felder ausgefüllt!", message: userMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
