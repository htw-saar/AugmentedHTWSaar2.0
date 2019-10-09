//
//  RestHistoryService.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 14.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous



/*
 Initiates the service call via REST to get a list of the latest reservations
 */
class RestHistoryService{
    
    static let INSTANCE = RestHistoryService()
    
    //standard constructor
    init(){}
    

    /*
     Function calls backend REST service and returns a list of all rooms this user has booked in the past
     */
    func getRooms() -> [String]?{
        
        let request = HMAC.jsonRequest(url: "/api/v1/room/history");
        let roomList = Alamofire.request(request).responseObject([String: String].self)
        
        if roomList == nil{
            return []
        }
        
        return Array(Set(roomList!.values))
    }
    
    
    func callHistoryServiceMock ()  -> ([Room]) {
        
        var reservations: [Room] = [];

        reservations.append(RestRoomService.INSTANCE.getRoom(roomNumber: "7111")!);
        reservations.append(Room.init(id: "1111", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01 08:30:00.000+0000", to: "2019-01-01 08:45:00.000+0000", id: 0220, label: "kp")], equipment: [
            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        

        
        reservations.append(Room.init(id: "2222", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01T08:30:00.000+0000", to: "2019-01-01 08:45:00.000+0000", id: 0220, label: "kp")], equipment: [
            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        

        
        reservations.append(Room.init(id: "3333", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01 08:30:00.000+0000", to: "2019-01-01 08:45:00.000+0000", id: 0220, label: "kp")], equipment: [
            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        

        
        reservations.append(Room.init(id: "4444", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01 08:30:00.000+0000", to: "2019-01-01 08:45:00.000+0000", id: 0220, label: "kp")], equipment: [
            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        
        return reservations;
    }
    
}
