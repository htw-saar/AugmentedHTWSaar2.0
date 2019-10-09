//
//  RoomTableViewCell.swift
//  AugmentedHTWSaarEsch
//
//  Created by Nicolas Klein on 02.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    var room: Room!
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconRoomStatus: UIImageView!
    @IBOutlet weak var iconWhiteBoard: UIImageView!
    @IBOutlet weak var iconMicro: UIImageView!
    
    
    func has(_ equipment: String) -> Bool{
        for element in room.equipment{
            if element.name == equipment {
                return true
            }
        }
        
        return false
    }
    
    func setRoom(room: Room) {
        self.room = room
        
        let current = Date()
        
        iconRoomStatus.image = room.isAvailable(current, current) ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "cross")
        iconWhiteBoard.image = has("whiteboard") ?  #imageLiteral(resourceName: "whiteboard") : nil
        iconMicro.image = has("mikrofon") ?  #imageLiteral(resourceName: "micro") : nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
