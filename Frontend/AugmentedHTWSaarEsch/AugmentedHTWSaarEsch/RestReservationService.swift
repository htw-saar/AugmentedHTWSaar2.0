//
//  RestReservationService.swift
//  AugmentedHTWSaarEsch
//
//  Created by CHW on 14.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous



/*
 Initiates the service call via REST to make or cancel a reservation
 */
class RestReservationService{
    
    static let INSTANCE = RestReservationService()
    
    //standard constructor
    init(){}
    
    /*
     Calls the backend roomService API to make a reservation. Returns ReservationResponse struct.
     Formats need to be: date: YYYY-MM-DD, times: HH:MM
    */
    func bookRoom(roomNumber: String, date: String, fromTime: String, toTime: String, reservationNote: String) -> ReservationResponse?{
        
        let escapedNote = reservationNote.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil);
        
        let curUser = User.current.apiUser
        
        let request = HMAC.jsonRequest(url: "/api/v1/room/book/\(roomNumber)?key=C89DFAE6-F9C1-44D0-9A12-55AE1864532F&date=\(date)&from=\(fromTime)&to=\(toTime)&user=\(curUser ?? "niklein")&event=\(escapedNote)");
        let reservationResponse = Alamofire.request(request).responseObject(ReservationResponse.self)
            
        return reservationResponse;
    }
    
    /*
     Calls the backend roomService API to cancel a reservation. Returns bool success.
     */
    func cancelRoom(roomNumber: String, date: String, fromTime: String, toTime: String) -> ReservationResponse?{
        
        let curUser = User.current.apiUser
        
        let request = HMAC.jsonRequest(url: "/api/v1/room/cancel/\(roomNumber)?key=C89DFAE6-F9C1-44D0-9A12-55AE1864532F&date=\(date)&from=\(fromTime)&to=\(toTime)&user=\(curUser ?? "niklein")");
        let reservationResponse = Alamofire.request(request).responseObject(ReservationResponse.self)
        
        return reservationResponse;
    }
    
    /*
     Mock function for GUI testing purpose
     */
    func callReservationServiceMock (roomNumber: Int, isCancelation: Bool, reservationNote: String)  -> (Bool, String) {
        if(isCancelation && roomNumber==1234){return (true, "Raum storniert");}
        if(!isCancelation && roomNumber==1234){return (true, "Raum reserviert")}
        if(isCancelation && roomNumber==5678){return (false, "Kein Zugriff. Raum durch anderen User reserviert");}
        if(isCancelation && roomNumber==6666){return (false, "Keine Reservierung gefunden");}
        
        return (false, "Bitte korrekte Raumnummer eingeben, du Dermel *CreepySmiley");
    }
    

}
