//
//  RoomService.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 08.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation

/*
 RoomService struct containing all relevant attributes e.g. the current room status and required information about the room.
 */
struct RoomService: Decodable{
    var roomNumber:Int?
    var currentRoomStatus:RoomStatus?
    var currentLectureName:String?
    var slots: Array<Bool> = Array(repeating: false, count: 6) //contains the 6 standard slots, initial value false == occupied
    var campus:String?
    var building:Int?
    var floor:Int?
    var typeDescription:String?
    var size:Int?
    var sizeLecture:Int?
    var sizeExam:Int?
    var largeLectureHall:Bool?
    var accessibly:Bool?
    var roomDarkening:Bool?
    var blackboard:Bool?
    var flipchart:Bool?
    var videoProjector:Bool? //Beamer (german)
    var whiteScreen:Bool? //Leinwand (german)
    var lecturerPC:Bool?
    var smartboard:Bool?
    var whiteboard:Bool?
    var overheadProjector:Bool?
    var microphone:Bool?
    var ventilation:Bool?
    var airConditioning:Bool?
    var publiclyAccessible:Bool?
}
