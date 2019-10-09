//
//  LoginViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christian Herz on 13.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController{
    
    //Username Feld
    @IBOutlet weak var usernameTextField: UITextField!
    //Passwort Feld
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var shortcutButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Translate.translate(usernameTextField, label: "username")
        Translate.translate(passwordTextField, label: "password")
        
        Translate.translate(loginButton, label: "login")
        Translate.translate(shortcutButton, label: "shortcut")
        Translate.translate(registerButton, label: "register")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO fix dump user or delete it
    @IBAction func shortcutButtonPressed(_ sender: UIButton) {
        //use of let or var with value acessed type struct
        //login(apiUser: "cwarken", apiSecret: "secret")
        performSegue(withIdentifier: "segueToScanner", sender: self)
    }
    @IBAction func loginButton(_ sender: Any) {
        
        
        if (usernameTextField.text == "" || passwordTextField.text == ""){
                displayAlertMessage(userMessage: "Sie haben nicht alle Felder ausgefüllt", additionalMessage: "Bitte füllen Sie alle Felder aus")
                return;
        } else {
            login(apiUser:usernameTextField.text!,apiSecret: passwordTextField.text!)
            
            
            let user = RestUserService.INSTANCE.getUser()
            
            if( user?.apiUser == usernameTextField.text ){
                usernameTextField.text = ""
                passwordTextField.text = ""
                performSegue(withIdentifier: "segueToScanner", sender: self)
            }else{
                displayAlertMessage(userMessage: "Password oder Username stimmen nicht überein", additionalMessage: "Bitte versuchen Sie es erneut!")
            }
        }
    }
    
    func login(apiUser:String, apiSecret:String){
        User.current = User( apiUser: apiUser, apiSecret: apiSecret)
    }
    
    @IBAction func registerButton(_ sender: Any) {
    }
    
    func displayAlertMessage(userMessage: String, additionalMessage: String){
        let alert = UIAlertController(title: userMessage, message: additionalMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Using User.current instead
        /*if(segue.destination is ARViewController)
        {
            let vc = segue.destination as? ARViewController
            vc?.user = user
        }
        else if (segue.destination is HistoryViewController){
            let vc = segue.destination as? HistoryViewController
            vc?.user = user
        }*/
    }
    
    /*Diese Funktionen dient blendet dazu die Tastatur auszublenden.
     Dies geschieht durch Drücken des Return-buttons
     */
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    /*Diese Funktion dient dazu die Tastatur auszublenden.
     Dies geschieht, indem man eine beliebige Stelle außerhalb des Tastaturfeldes berührt
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
