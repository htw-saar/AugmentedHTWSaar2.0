//
//  SprechzeitenViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Philipp Kügler on 21.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import UIKit

class SprechzeitenViewController: UIViewController {
    
    //Konstanten
    let pdfUmwandler = PdfUmwandler()

    @IBOutlet weak var btnSpeichern: UIButton!
    @IBOutlet weak var txtViewSprechzeiten: UITextView!
    
    //Variablen
    var raum = Raum()
    var user = User()
    var restSchnittstelleSprechzeiten = RestSchnittstelleSprechzeiten()

    
    /*
     Überschreibt die Funktion viewWillAppear. Hier werden alle Einstellungen zum laden der View vorbereitet
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sprechzeiten = restSchnittstelleSprechzeiten.getSprechzeitenZuProfUndRaum(raumNr: raum.raumnummer!, benutzerID: (raum.verantwortlicher?.benutzerID!)!)
        
        txtViewSprechzeiten.text = "Montag: \(sprechzeiten.montag!)\nDienstag: \(sprechzeiten.dienstag!)\nMittwoch: \(sprechzeiten.mittwoch!)\nDonnerstag: \(sprechzeiten.donnerstag!)\nFreitag: \(sprechzeiten.freitag!)\nNachricht: \(sprechzeiten.nachricht!)"
        if user.rollenID == 2 {
            btnSpeichern.isHidden = true
        }

    }

    /*
    Funktion zum übertragen der geänderten Sprechzeiten konnt nicht implementiert werden
    */
    @IBAction func speichern(_ sender: Any) {
        
    }
    
    /*
     Überschreibt die Funktion prepare, dass wenn man zu dem ViewController zurück geht, die User-Struct
     beibehalten wird. Wird benötigt, dass man sicher immer mit dem angemeldeten User Daten verarbeitet
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is ViewController)
        {
            let vc = segue.destination as? ViewController
            vc?.raum = raum
            vc?.user = user
        }
    }
    

    @IBAction func speichernAlsPdf(_ sender: Any) {
        let dokumentName = pdfUmwandler.umwandeln(text: txtViewSprechzeiten.text)
        
        let nachricht = "Pdf gespeichert unter: " + (dokumentName) as String
        let alert = UIAlertController(title: "Speichern erfolgreich", message: nachricht, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
