//
//  KontaktViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Julian Bur on 14.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import UIKit

class KontaktViewController: UIViewController, UITextFieldDelegate {

    //Labels
    @IBOutlet weak var kontakformularLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    
    //Textfelder
    @IBOutlet var betreffTextField: UITextField!
    @IBOutlet var prioritaetTextField: UITextField!
    @IBOutlet var nachrichtenTextField: UITextField!
    
    //Variablen und Konstanten
    let limit = 300
    var user = User()
    var raum = Raum()
    var kontakt = Kontakt()
    
    var restSchnittstelleKontakt = RestSchnittstelleKontakt()
    

    @IBAction func senden(_ sender: Any) {
        if(betreffTextField.text == "" || prioritaetTextField.text == "" || nachrichtenTextField.text == "")
        {
            displayMyAlertMessage(userMessage: "Bitte alle Felder ausfüllen!");
            return
        }
        //erstellene einer kontakt sruct
        kontakt.raumnummer = self.raum.raumnummer!
        kontakt.sender = self.user
        kontakt.empfaenger = self.raum.verantwortlicher
        kontakt.betreff = self.betreffTextField.text
        kontakt.prio = Int(self.prioritaetTextField.text!)
        kontakt.nachricht = self.nachrichtenTextField.text
        
        let antwort = restSchnittstelleKontakt.neueNachricht(kontakt: kontakt);
        displayMyAlertMessage(userMessage: antwort);
        betreffTextField.text = "";
        prioritaetTextField.text = "";
        nachrichtenTextField.text = "";
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nachrichtenTextField?.delegate = self
    
        countCharacters.text = String(limit)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Durch diese Funktion wird ein Zeichenzähler für ein Textfeld implementiert. Hierbei wird von einem
     fesgesetzten Limit bis auf null heruntergezaehlt. In unserem Fall wurde das Limit auf 300 gesetzt.
     */
    func textField(_ nachrichtenTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Optional Unwrapping mittels guard let - Konstrukt
        guard let text = nachrichtenTextField.text else { return true }
        
        let newLength = text.count  + string.count - range.length
        var count = limit - newLength
        if(count == -1) {
            count = 0
        }
        countCharacters.text = String(count)
        
        return newLength <= limit
    }
    
    func displayMyAlertMessage(userMessage: String){
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true)
    }
    /*
    Überschreibt die Funktion prepare, dass wenn man zu dem ViewController zurück geht, die User-Struct
    beibehalten wird. Wird benötigt, dass man sicher immer mit dem angemeldeten User Daten verarbeitet
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is ViewController)
        {
            let vc = segue.destination as? ViewController
            vc?.user = user
        }
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
