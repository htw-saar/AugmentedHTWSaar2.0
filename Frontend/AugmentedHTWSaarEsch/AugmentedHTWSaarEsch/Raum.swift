//
//  Raum.swift
//  AugmentedRealityHTWSaar
//
//  Created by Marco Becker on 18.07.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import Foundation

/*
 Struct das alle informationen zu einem Raum bereithält
 */
struct RaumDeprecated: Decodable{
    var raumnummer:Int?
    var verantwortlicher:User?
    var raumartID:Int?
    var raumartBezeichnung:String?
    var htwSeite:String?
    

}
