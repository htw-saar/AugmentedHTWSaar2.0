//
//  RoomStatus.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 14.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation

/*
 Represents the current status of the scanned room. Needed to enable or disable various functions in GUI
 */

enum RoomStatus: String, Codable{

    case free
    case bookedByMyself
    case bookedByOtherPerson
    
}
