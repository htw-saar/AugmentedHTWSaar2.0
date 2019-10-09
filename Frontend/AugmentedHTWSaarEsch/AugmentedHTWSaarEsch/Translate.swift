//
//  Translate.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christopher Jung on 16.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire


class Translate{
    
    static var translation: Translate? = nil
    
    var table = [String : String]()
    
    
    static func getTranslation() -> Translate{
        if(translation == nil){
            translation = load();
        }
        
        return translation!
    }
    
    static func translate(name: String) -> String? {
        return getTranslation().translate(name)
    }
    
    init( table : [String : String] ){
        self.table = table
    }
    
    init(){
        
    }
    
    func translate(_ name: String) -> String? {
        return table[name]
    }
    
    static func save(translation: Translate) -> Void{
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: translation)
        userDefaults.set(encodedData, forKey: "translation")
        if(userDefaults.synchronize()){
            self.translation = translation
        }
    }
    
    static func load() -> Translate{
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "translation")
        
        if decoded == nil {
            return loadFromServer()
        }else{
            return NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Translate
        }
    }
    
    static func loadFromServer() -> Translate{
        let urlRequest = HMAC.jsonRequest(url: "/api/v1/translation/\(Locale.preferredLanguages[0].split(separator: "-")[0])")
        let response = Alamofire.request(urlRequest).responseJSON()
        
        let test = response.result.value
        
        if let value = test as? [String: String] {
            let translate = Translate(table: value)
            //Translate.save(translation: translate)
            return translate
        }
        
        return Translate()
    }
    
    static func translate( _ uiControl: UIView, label: String ){
        
        let value = translate(name: label) ?? label
        
        
        if let button = uiControl as? UIButton {
            button.setTitle(value, for: button.state)
        }else if let label = uiControl as? UILabel {
            label.text = value
        }else if let textView = uiControl as? UITextField {
            textView.placeholder = value
        }
    }
}
