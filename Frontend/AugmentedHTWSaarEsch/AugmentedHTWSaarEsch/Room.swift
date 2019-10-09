//
//  Room.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christopher Jung on 10.08.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation


struct Room: Decodable{
    var id:String!
    var seatsTotal: Int32!
    var type: String!
    var location: Location!
    var schedule: [TimeSlot]!
    var equipment: [Equipment]!
    
    func isAvailable(_ from:Date,_ to:Date ) -> Bool{
        if schedule != nil {
            for timeSlot in schedule!{
                if(timeSlot.intersect(from:from, to:to)){
                    return false
                }
            }
            
            return true
        }
        
        return false
    }
}
