//
//  SeiteViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Marco Becker on 17.09.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import UIKit
import WebKit

/*
 Controller Klasse zum Anzeigen von der Web-View, damit man die hinterlegt HTW-Seite zu dem Professor angezeigt bekommt
 */
class SeiteViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var user = User()
    var raum = Raum()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
               
        //Aufruf der HTTP-Seite
        let url:URL = URL(string: raum.htwSeite!)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Überschreibt die FUnktion prepare, dass wenn man zu dem ViewController zurück geht, die User-Struct
     beibehalten wird. Wird benötigt, dass man sicher immer mit dem angemeldeten User Daten verarbeitet
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is ViewController)
        {
            let vc = segue.destination as? ViewController
            vc?.user = user
        }
    }

}
