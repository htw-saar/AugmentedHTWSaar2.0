//
//  RoomViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Nicolas Klein on 03.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import UIKit
import os.log

class RoomDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    var room:Room!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindSegueToRoomList", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        title = room.location.roomNumber
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === cancelButton else {
            return
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.equipment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelDetailCell") as! RoomDetailCell
        
        cell.info.text = room.equipment![indexPath.row].name
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


}
