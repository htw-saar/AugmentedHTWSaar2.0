//
//  RestFavoritesService.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 14.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous



/*
 Initiates the service calls via REST to manage a list of favorite rooms
 */
class RestFavoritesService{
    
    static let INSTANCE = RestFavoritesService()
    
    //standard constructor
    init(){}
    
    /*
     Function calls backend REST service and returns a list of rooms
     */
    func getRooms() -> [String]? {
  
            var roomList: [String]!
            let request = HMAC.jsonRequest(url: "/api/v1/room/favorite");
            roomList = Alamofire.request(request).responseObject([String].self)
            
            return roomList ?? []
    }
    
    /*
     Function handles editing of the favorites list via REST interface. Available operations are PUT and DELETE.
    */
    func editRooms(roomNumber: String, operation: String) -> Bool {
        
        var request = HMAC.jsonRequest(url: "/api/v1/room/favorite/\(roomNumber)");
        request.httpMethod = operation
        return Alamofire.request(request).responseData().response?.statusCode == 200
    }
    
    //Mock function for GUI testing purpose
    func callFavoritesServiceMock ()  -> ([Room]) {
        
        var reservations: [Room] = [];
        

        reservations.append(Room.init(id: "1234", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01T08:30:00.000+0000", to: "2019-01-01T08:45:00.000+0000", id: 0220, label: "kp")], equipment: [

            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        

        reservations.append(Room.init(id: "4567", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01T08:30:00.000+0000", to: "2019-01-01T08:45:00.000+0000", id: 0220, label: "kp")], equipment: [

            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        
        
        reservations.append(Room.init(id: "9999", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01T08:30:00.000+0000", to: "2019-01-01T08:45:00.000+0000", id: 0220, label: "kp")], equipment: [
            Equipment(details: "das ist ein beamer", name: "blackboard", present: true),
            Equipment(details: "das ist ein beamer", name: "videoProjector", present: true),
            Equipment(details: "das ist ein beamer", name: "whiteScreen", present: true),
            Equipment(details: "das ist ein beamer", name: "microphone", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true),
            Equipment(details: "das ist ein beamer", name: "beamer", present: true)
            ]));
        
        
        reservations.append(Room.init(id: "2222", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01T08:30:00.000+0000", to: "2019-01-01T08:45:00.000+0000", id: 0220, label: "kp")], equipment: [
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
