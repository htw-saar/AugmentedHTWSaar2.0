//
//  Config.swift
//  AugmentedRealityHTWSaar
//
//  Created by CHW on 14.07.19
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import Foundation

/*
 Klasse zum Einstellen der Server-/Localhost Adresse, sowie Aktivierung der REST-Mock zu Testzwecken
 */
class Config{
    // let url: String = "http://192.168.0.101:1337";
    //static let url: String = "http://192.168.178.52:8080";
    //static let url: String = "http://192.168.1.36:8080"; //Chris iMac
    static let url: String = "http://192.168.178.63:8080"; //Nico Macbook
    //static let url: String = "http://localhost:8080"; //localhost
    //static let url: String = "http://nyx.tcmpk.de:8080"; //Server PK zur Vorführung Prototyp auf iPad
    
    
    static let usingMock = false
}
