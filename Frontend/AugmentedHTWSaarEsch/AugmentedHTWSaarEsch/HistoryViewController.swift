//
//  HistoryViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Nicolas Klein on 02.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import UIKit
import os.log

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    static let favoritesPage = 0
    static let historyPage = 1

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Fields
    var historyList: [String] = []
    var favoriteList: [String] = []
    
    
    //The table which is shown currently.
    //Either history or favourites
    var currentTableView: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.setTitle(Translate.translate(name: "favorites") ?? "Favouriten", forSegmentAt: 0)
        segmentControl.setTitle(Translate.translate(name: "history") ?? "Verlauf", forSegmentAt: 1)
        
        
        currentTableView = HistoryViewController.favoritesPage
        //tableView.backgroundColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        historyList = RestHistoryService().getRooms() ?? []
        favoriteList = RestFavoritesService().getRooms() ?? []
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // If a segue is about to be executed, this method gets triggered
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Going to prepare method of historyviewcontroller")
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier) {
            
            case "showRoomDetails":
                
                guard let destinationNavigationController = segue.destination as? UINavigationController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                let roomDetailController = destinationNavigationController.topViewController as! RoomDetailController
            
            
                guard let selectedCell = sender as? RoomTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let roomNumber = getListItem(indexPath.row);
                
                let room = RestRoomService.INSTANCE.getRoom(roomNumber: roomNumber);
                
                roomDetailController.room = room
                
                print("Switching to room details")
            
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        guard let selectedCell = sender as? RoomTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let roomNumber = getListItem(indexPath.row);
        
        return RestRoomService.INSTANCE.getRoom(roomNumber: roomNumber) != nil
    }
    
    @IBAction func unwindToRoomList(segue:UIStoryboardSegue) { }
    
    //MARK: SegmentControl
    
    //If the segment controll is pressed, the table view gets reloaded
    @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
        currentTableView = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    // MARK: TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getListItemCount()
    }
    
    func getListItemCount( ) -> Int {
        if(currentTableView ==  HistoryViewController.favoritesPage)
        {
            return favoriteList.count;
        }
        else if(currentTableView ==  HistoryViewController.historyPage)
        {
            return historyList.count;
        }
        else
        {
            fatalError("Page unknown")
        }
    }
    
    func getListItem( _ index: Int ) -> String {
        if(currentTableView ==  HistoryViewController.favoritesPage)
        {
            return favoriteList[index];
        }
        else if(currentTableView ==  HistoryViewController.historyPage)
        {
            return historyList[index];
        }
        else
        {
            fatalError("Page unknown")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as! RoomTableViewCell
        
        let listItems = getListItem(indexPath.row)
        
        cell.textLabel?.text = listItems
        let room = RestRoomService.INSTANCE.getRoom(roomNumber: listItems);

        cell.setRoom(room: room!)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
