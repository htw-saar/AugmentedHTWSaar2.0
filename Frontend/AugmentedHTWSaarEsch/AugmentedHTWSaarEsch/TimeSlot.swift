//
//  TimeSlot.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christopher Jung on 10.08.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation

struct TimeSlot: Decodable{

    var from: String!
    var to: String!
    var id: Int64!
    var label: String!
    
    func getFrom() -> Date{
        return TimeUtils.isoDate(str: from)!
    }
    
    func getTo() -> Date{
        return TimeUtils.isoDate(str: to)!
    }
    
    func intersect(from:Date, to:Date) -> Bool{
        return getTo().compareTimeOnly(to: from) == .orderedDescending
            && getFrom().compareTimeOnly(to: to) == .orderedAscending
    }
}
