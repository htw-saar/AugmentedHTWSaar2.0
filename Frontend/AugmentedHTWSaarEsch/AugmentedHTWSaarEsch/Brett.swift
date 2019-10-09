//
//  SchwarzesBrett.swift
//  AugmentedHTWSaarEsch
//
//  Created by Konrad Zuse on 14.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class BrettDepre{
    
    //Klassen Variablen
    var webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
    
    //Klassen Konstanten
    let widthBigBox = CGFloat(0.5)
    let heightBigBox = CGFloat(0.75/2)
    let lengthBigBox = CGFloat(0.05)
    let raumSchnittstelle = RestSchnittstelleRaum()
    
    //Konstruktor
    init(){}
    
   
    /*
    Erzeugt einen virtuellen Bildschirm, der eine URL anzeigt
    Das Anzeigen der URL oder anderer Informationen auf dem Schwarzen Brett führt dazu, dass
    alle anderen Views nicht benutzbar sind, der Fehler konnt nicht gefunden werden
     
     Schwarzes Brett bleibt leer
    */
    /*
     TODO: Delete useless attribute NicolasKlein
     */
    func erzeugeSchwarzesBrett(imageName: String, raum: Room) -> SCNNode {
        
        let request = URLRequest(url: URL(string: raum.htwSeite!)!)
        
        DispatchQueue.main.async(execute: { //Sorgt dafür, dass webView im Main Thread ausgeführt wird
            self.webView.loadRequest(request)

        })
        
        let tvPlane = SCNPlane(width: widthBigBox, height: heightBigBox)
        //tvPlane.firstMaterial?.diffuse.contents = webView // auskommentiert, da probleme mit main thread
        tvPlane.firstMaterial?.isDoubleSided = true
        
        //Erzeugt die verschiedene Elemente des Bildschirms
        let backgroundBox = SCNNode(geometry: SCNBox(width: widthBigBox, height: heightBigBox, length: lengthBigBox, chamferRadius: 0))
        backgroundBox.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameLeft = SCNNode(geometry: SCNBox(width: 0.05, height: heightBigBox, length: 0.15, chamferRadius: 0))
        frameLeft.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameRight = SCNNode(geometry: SCNBox(width: 0.05, height: heightBigBox, length: 0.15, chamferRadius: 0))
        frameRight.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameUp = SCNNode(geometry: SCNBox(width: 0.6, height: 0.05, length: 0.15, chamferRadius: 0))
        frameUp.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameDown = SCNNode(geometry: SCNBox(width: 0.6, height: 0.05, length: 0.15, chamferRadius: 0))
        frameDown.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        
        let tvPlaneNode = SCNNode(geometry: tvPlane)
        
        //Fügt die Elemente zusammen, so das sie ein Bildschirm ergeben
        frameDown.position = SCNVector3(0 , heightBigBox/2 + 0.025 , 0.025)
        frameUp.position = SCNVector3(0 , -heightBigBox/2 - 0.025 , 0.025)
        frameLeft.position = SCNVector3(-widthBigBox/2-0.025 , 0 , 0.025)
        frameRight.position = SCNVector3(widthBigBox/2+0.025 , 0 , 0.025)
        tvPlaneNode.position = SCNVector3(0,0,0.07)
        
        backgroundBox.addChildNode(tvPlaneNode)
        backgroundBox.addChildNode(frameLeft)
        backgroundBox.addChildNode(frameRight)
        backgroundBox.addChildNode(frameUp)
        backgroundBox.addChildNode(frameDown)
        
        return backgroundBox;
    }
}
