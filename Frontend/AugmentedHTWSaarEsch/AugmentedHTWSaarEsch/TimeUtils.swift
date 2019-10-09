//
//  TimeUtils.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christopher Jung on 19.08.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation

class TimeUtils{
    
    static var longFormatter: DateFormatter! = nil
    static var isoFormatter: DateFormatter! = nil
    
    static func getLongFormatter() -> DateFormatter {
        if(longFormatter == nil){
            longFormatter = DateFormatter()
            longFormatter.timeZone = TimeZone.current
            longFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        return longFormatter
    }
    
    static func getIsoFormatter() -> DateFormatter {
        if(isoFormatter == nil){
            isoFormatter = DateFormatter()
            isoFormatter.timeZone = TimeZone.current
            isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
        
        return isoFormatter
    }
    
    static func longDate( str:String ) -> Date?{
        return getLongFormatter().date(from: str)
    }
    
    static func longString( date:Date ) -> String?{
        return getLongFormatter().string(from: date)
    }
    
    static func isoDate(str:String) -> Date?{
        return getIsoFormatter().date(from: str)
    }
    
    // returns a current date String
    static func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
