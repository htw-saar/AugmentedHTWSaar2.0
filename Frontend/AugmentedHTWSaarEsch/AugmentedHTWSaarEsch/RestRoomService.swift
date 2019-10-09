//
//  RestRoomService.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 08.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous


/*
 Initiates the service call via REST to get the room-service information
 */
class RestRoomService{
    
    static let INSTANCE = RestRoomService()
    
    //standard constructor
    init(){}
    
    /*
     Calls the backend roomService API to get the room status and all attributes. Parses received JSON objects to a struct and returns it.
     */
    func getRoom( roomNumber: String ) -> Room?{
        if(!Config.usingMock){
            
            let dateStr = TimeUtils.getCurrentDate()
            let request = HMAC.jsonRequest(url: "/api/v1/room/\(roomNumber)?date_beg=\(dateStr)&date_end=\(dateStr)");
            
            let room = Alamofire.request(request).responseObject(Room.self)
            //print(room?.schedule![0].from!)
            
            return room;
        }else{
            return callRoomServiceMock(roomNumber: roomNumber)
        }
    }
    
    
    /*
     Mocks the backend roomService API to get the room status and all attributes. Parses received JSON objects to a struct and returns it.
     */
    func callRoomServiceMock (roomNumber: String)  -> (Room) {

        var room = Room.init(id: "2233", seatsTotal: 199, type: "Vorlesungsraum", location: Location(building: "8", campus: "alt", floor: "1", roomNumber: "7111"), schedule: [TimeSlot(from: "2019-01-01T08:30:00.000+0000", to: "2019-01-01T08:45:00.000+0000", id: 0220, label: "kp")], equipment: [Equipment(details: "das ist ein beamer", name: "Beamer", present: true),Equipment(details: "das ist eine Klimaanlage", name: "Klimaanlage", present: true),Equipment(details: "das ist ein Whiteboard", name: "Whiteboard", present: true)]);
  
        room.location?.roomNumber = roomNumber
    
        return room;
    }
}
