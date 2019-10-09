//
//  PdfUmwandler.swift
//  AugmentedHTWSaarEsch
//
//  Created by Philipp Kuegler on 28.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import Foundation
import PDFKit

class PdfUmwandler {
    
    //var fileManagaer:FileManager?
    var documentDir:NSString?
    var filePath:NSString?
    
    init(){}
    
    
    /*
     Wandelt einen übergebenen String in eine PDF Datei um und speichert diese lokal ab.
     Leider lässt das IPad es nur zu in der App selbst die PDF zu speichern, gleichzeitig
     kann man auf den Ordner von außerhalb der App nicht zu greifen
     */
    func umwandeln(text: String) -> String  {
        
        let dirPaths:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        documentDir=dirPaths[0] as? NSString
        print("path : \(String(describing: documentDir))")
        

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 500, height: 300))
        
        let pdf = renderer.pdfData { (context) in
            context.beginPage()
            
            let font = UIFont.boldSystemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            
            text.draw(in: CGRect(x: 0, y: 0, width: 500, height: 700), withAttributes: attributes)
        }
        
        var dokumentName = documentDir! as String
        dokumentName += "/test.pdf"
        let url = URL(fileURLWithPath: dokumentName)
        try! pdf.write(to: url)
        
        return dokumentName
        
    }
}
