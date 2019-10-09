//
//  RegistrationViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christian Herz on 13.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
   
    
    @IBOutlet weak var labelUsername: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Translate.translate(usernameTextField,label: "username")
        Translate.translate(emailTextField, label: "email")
        Translate.translate(passwordTextField, label: "password")
        Translate.translate(nameTextField, label: "name")
        Translate.translate(surnameTextField,label:  "lastname")
        
        Translate.translate(labelUsername,label: "username")
        Translate.translate(labelEmail, label: "email")
        Translate.translate(labelPassword, label: "password")
        Translate.translate(labelName, label: "name")
        Translate.translate(labelLastName,label:  "lastname")
        
        Translate.translate(backButton,label:  "back")
        Translate.translate(registerButton,label:  "register")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        // Initialize Parameters for Registration
        let username = usernameTextField.text;
        let email = emailTextField.text;
        let password = passwordTextField.text;
        let surname = surnameTextField.text;
        let name = nameTextField.text;
        //let rolleDesUsers = rolle;
        
        //Check for empty fields
        if((username?.isEmpty)! || (email?.isEmpty)! || (password?.isEmpty)! || (surname?.isEmpty)! || (name?.isEmpty)! ){
            //Display alert message
            displayMyAlertMessage(userMessage: "All fields are required!");
            return;
        }
        
        var newUser = User(apiUser: username!, apiSecret: password!)
        
        
        newUser.firstName = name
        newUser.lastName = surname
        newUser.eMail = email
        
        
        let result = RestUserService.INSTANCE.createUser(user: newUser)
        
        if result != nil {
            usernameTextField.text = ""
            passwordTextField.text = ""
            emailTextField.text = ""
            surnameTextField.text = ""
            nameTextField.text = ""
            
            User.current = result!
            performSegue(withIdentifier: "segueToScannerFromRegister", sender: self)
        }
    }
    
    
    
    func displayMyAlertMessage(userMessage: String){
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true)
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
