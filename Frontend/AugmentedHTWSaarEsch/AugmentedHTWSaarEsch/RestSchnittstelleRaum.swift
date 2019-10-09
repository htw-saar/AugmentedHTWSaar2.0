//
//  RestSchnittstelleRaum.swift
//  AugmentedRealityHTWSaar
//
//  Created by Marco Becker on 14.07.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous


/*
 Schnittstellenfunktion zum aufrufen des Servers um alle Informationen über den gesuchten Raum zu bekommen
 */
class RestSchnittstelleRaum{
   
    
    
    init(){}
    /*
     Funktion zum abrufen alle Rauminformationen vom Server. Bekommt als Antwort ein JSON Object zurück,
     das in eine Raum Struct umgewandelt wird
     */
    func getRaumInformation (raumnummer: Int)  -> Raum {
        
        let response = Alamofire.request("\(Config.url)/raum/rauminfo/\(raumnummer)").responseData();
        let decoder = JSONDecoder()
        var raum = try? decoder.decode(Raum.self, from: response.data!)
        
        return raum!;
    }
}
