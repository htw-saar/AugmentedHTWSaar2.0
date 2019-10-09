//
//  ARViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Nicolas Klein on 25.06.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import UIKit

import UIKit
import ARKit
//import SceneKit

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var bookingPopupTitle: UILabel!
    
    //MARK: Fields
    let ARScene = SCNScene()
    let service = RestRoomService()
    
    
    //current room
    var currentRoom:Room! = nil
    var currentRoomName:String? = nil
    
    //MARK: Outlets
    @IBOutlet weak var ARView: ARSCNView!
    @IBOutlet weak var bookARButton: UIButton!

    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        Translate.translate(bookARButton, label:"book")
        Translate.translate(logoutButton, label:"logout")
        Translate.translate(fromLabel, label:"from")
        Translate.translate(toLabel, label:"to")
        Translate.translate(cancelButton, label:"cancel")
        Translate.translate(bookButton, label:"book")
        Translate.translate(bookingPopupTitle, label:"booking")
        

        //ARView setup
        ARView.delegate = self
        ARView.session.delegate = self
        ARView.autoenablesDefaultLighting = true
        ARView.automaticallyUpdatesLighting = true
        ARView.scene = ARScene
        
        //Round Book Button
        bookARButton.layer.cornerRadius = 10
        bookARButton.clipsToBounds = true
        
        //Hide Book Button
        bookARButton.isHidden = true
        
        //Bookingdetails popup
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        bookingDetailsView.layer.cornerRadius = 5
        
        //Fills Begin- and EndSlots with values
        fillSlots()
        
        
        let curuser = User.current
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuartion = ARWorldTrackingConfiguration()
        
        configuartion.planeDetection = .vertical
        configuartion.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        
        ARView.debugOptions =  [ARSCNDebugOptions.showFeaturePoints]
        ARView.session.run(configuartion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ARView.session.pause()
    }
    
    //MARK: Navigation
    @IBAction func goBackToLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     Should fix RestRoomService returning nil if no bookings for that day on that specific room
    */
    func fixNoDataFromRestBug(slot: Int){
        let resService = RestReservationService()
        
        let startTime =  getStringTime(from: getStartDate(index: slot))
        let endTime = getStringTime(from: getEndDate(index: slot))
        let result = resService.bookRoom(roomNumber: self.currentRoomName!, date: getStringDate(from: Date()), fromTime: startTime, toTime: endTime, reservationNote: "Reservation to test new features")
        
        if(result?.success! ?? false){
            print("fixData Reservation success")
        }
        else{
            print("fixData Reservation failed")
        }
        
        print("Fix Reservation Status: \(String(describing: result?.status))")
    }
    
    /*
     Prints all the schedule entries of a room object
    */
    
    func printSchedule(room: Room){
        for schedule in room.schedule{
            print(schedule)
        }
    }
    
    
    //Size of the last found plane
    var planeSize: CGSize? = nil
    
    /*
     MARK: ARKit
     When a reference Image is found for the first time a node is added at that position.
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            let name = imageAnchor.referenceImage.name!
            switchARBookButtonState(state: false)
            if(self.currentRoomName ?? "" != name){
                self.currentRoomName = name
                node.name = "currentNode"
                print("you found a \(name) image")
                
                removeAllNodes(exclude: "currentNode")
                node.name = "nonCurrent"
                
                //fixNoDataFromRestBug(slot: 4)
				
                currentRoom = service.getRoom(roomNumber: name)!
                //printSchedule(room: currentRoom!)
                
                let size = imageAnchor.referenceImage.physicalSize
                self.planeSize = size
                
                let planeNode = makePlane(size: size, color: getRoomColor())
                planeNode.name = "planeNode"
                
                let description = getDescriptionNode(height: -0.04)
                let roomSize = getRoomSizeNode(height: 0)

                
                let booleanNodes = getBooleanNodes(startHeight: 0.04, offSet: 0.04)
                for boolNode in booleanNodes{
                    node.addChildNode(boolNode)
                }
                
                node.addChildNode(planeNode)
                node.addChildNode(description)
                node.addChildNode(roomSize)
                node.opacity = 1
                
            }
        }
    }
    
    /*
     Reloads the plane with probably changed data
    */
    func reloadPlane(color: UIColor){
        self.currentRoom = service.getRoom(roomNumber: self.currentRoomName!)!
        printSchedule(room: currentRoom!)
        
        let node = getNodeWithName(nodeName: "nonCurrent")
        
        node?.enumerateChildNodes{ (node, stop) in
            let name = node.name ?? "wrongNode"
            if (name == "planeNode"){
                node.removeFromParentNode()
            }}
        
        node?.addChildNode(makePlane(size: self.planeSize!, color: color))
    }
    
    /*
     Searches for a node named nodeName
    */
    func getNodeWithName(nodeName: String) -> SCNNode?{
        var ourNode: SCNNode? = nil
        
        ARView.scene.rootNode.enumerateChildNodes { (node, stop) in
            let name = node.name ?? "wrongNode"
            if (name == nodeName){
                ourNode = node
            }}
        
        return ourNode
    }
    
    /*
     Switches the state of bookARButton isHidden on
     main thread.
     */
    
    func switchARBookButtonState(state: Bool){
        DispatchQueue.main.async {
            self.bookARButton.isHidden = state
        }
       
    }
    
    /*
     Removes all Nodes besides our new found node.
     This is used to delete all other nodes, when a
     new one is found in render(didAdd node:).
     The only way to identify a node is by its name.
     Default this proberty is nil. Therefor we set
     this in the render(didAdd node:) to "currentNode".
     Through that we know which nodes are safe to delete.
    */
    func removeAllNodes(exclude: String){
        //If tabbed button for arscanner is pressed, no sign gets detected what so ever
        //We dont know why
        ARView.scene.rootNode.enumerateChildNodes { (node, stop) in
            let name = node.name ?? "wrongNode"
            if (!(name == exclude)){
                node.removeFromParentNode()
            }}
    }
    
    /*
     Generates a description text node
    */
    func getDescriptionNode(height: CGFloat) -> SCNNode{
        let description = currentRoom!.type ?? "No Description"
        print(description)
        return makeText(text: description, height: height, color: UIColor.white)
    }
    
    /*
     Generates a roomSize text node
    */
    func getRoomSizeNode(height: CGFloat) -> SCNNode{
        let roomSize = currentRoom!.seatsTotal ?? 0
        var roomSizeText = "Room-Size: "
        if (roomSize == 0){
            roomSizeText.append("unknown")
        }
        else{
            roomSizeText.append(String(roomSize))
        }
        
        return makeText(text: roomSizeText, height: height, color: UIColor.white)
    }
  
    /*
     Adds all boolean text information to text-nodes using the makeText function
     and colors them according to their status as stated by the roomService
     */
    func getBooleanNodes(startHeight: CGFloat, offSet: CGFloat) -> Set<SCNNode>{
        var result = Set<SCNNode>()
        
        var height = startHeight
        
        for equipment in currentRoom!.equipment! {
            if equipment.present! {
                result.insert(makeText(text: equipment.name!, height: height, color: UIColor.white))
                height = height + offSet
            }
        }
        
        return result
    }
    
    
    /*
    Returns a UIColor element matching with the room status of the last
    scanned room.
    */
    func getRoomColor() -> UIColor{
        let curTime = Date()
        
        if (currentRoom.isAvailable(curTime, curTime)){
            return UIColor.green
        }
        return UIColor.red
    }
    
    /*
     Generates a plane with the color chosen by the attribute color
     */
    func makePlane(size: CGSize, color: UIColor) -> SCNNode{
        
        //Generates plane chosen color and size
        let colorPlane = SCNPlane(width: size.width, height: size.height)
        colorPlane.materials.first?.diffuse.contents = color
        
        //Adds the plane geometry to a new node
        let node = SCNNode(geometry: colorPlane)
        node.eulerAngles.x = -.pi / 2
        //node.scale = SCNVector3(0.5, 0.5, 0.5)
        
        return node
    }
    
    /*
     Generates a text with the specified size
     */
    func makeText(text: String, height: CGFloat, color: UIColor) -> SCNNode{
        let text = SCNText(string: text, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.00005
        text.firstMaterial?.diffuse.contents = color
        
        let textNode = SCNNode(geometry: text)
        //horizontale/abstand/verticale
        textNode.position = SCNVector3(0.18,0,height)
        textNode.scale = SCNVector3(x: 0.03, y: 0.03, z: 0.03)
        textNode.eulerAngles.x = 90.degreesToRadians.swf // make text straigth up
        textNode.eulerAngles.z = 180.degreesToRadians.swf // roate it by 180 degrees
        textNode.eulerAngles.y = 180.degreesToRadians.swf //Now looking at it from the front
        
        return textNode
    }
    
    
    
    /*
     ////////////////////
     MARK: Booking-Popup
     ////////////////////
    */
    
    
    //MARK: Outlets Popup
    @IBOutlet var bookingDetailsView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    
    //Is the Room marked as favorite?
    var favoriteState = false
    
    //Data shown in the picker
    var pickerData: [String] = [String]()
    
    //Slot in which we are currently in
    var currentSlot = -1
    
    //Index selected by the user
    var selectedIndex = 0
    
    //First booked room, no room after it can be booked
    var firstBookedRoom = -1
    
    //Stores our effect for later use
    var effect: UIVisualEffect!

    
    //All available time-slots
    var slotsBegin: [Date] = []
    
    //MARK: Methods Popup

    /*
     Fills date arrays with slotBegin and End times
    */
    func fillSlots(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        
        let begins = ["8:15","10:00","11:45","14:15","16:00","17:45"]
        
        slotsBegin.removeAll()
        for dateStr in begins {
            let date = formatter.date(from: dateStr)!
            slotsBegin.append(date)
        }
    }
    
    /*
     Finds current slot. It searches the first slot in slots
     which has a bigger End time that the current time.
    */
    func findCurrentSlot() -> Int{
        let date = Date()
        
        let nowHour = Calendar.current.component(.hour, from: date)
        let nowMinutes = Calendar.current.component(.minute, from: date) + nowHour * 60

        for (row,slot) in slotsBegin.enumerated(){
            
            let currentHour = Calendar.current.component(.hour, from: slot)
            let currentMinutes = Calendar.current.component(.minute, from: slot) + currentHour * 60
            
            let diffMinutes = nowMinutes - currentMinutes
            
            if( diffMinutes < 0 ){
                return row - 1
            }
            
            if( diffMinutes <= 90 ){
                return row
            }
        }
        
        return -1
    }
    
    /*
     Displays only the hour and minute of an date object.
    */
    func getStringTime(from date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    /*
     Displays only the year, month and day of date.
     */
    func getStringDate(from date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    /*
     Returns the beginning-time of the slot
     at position index of the slotsBegin Array
     */
    func getStartDate(index : Int) -> Date{
        return slotsBegin[index]
    }
    
    /*
     Adds 90 minutes to the beginning-time at a
     specified index of the slotsBegin Array.
     Therefor returns its end-time.
     */
    func getEndDate(index : Int) -> Date{
        return slotsBegin[index].addingTimeInterval(TimeInterval(90 * 60))
    }
    
    /*
     Sets the state of the favorite Button
    */
    func reloadFavoriteButtonState(){
        let favService = RestFavoritesService()
        
        
        
        let rooms = favService.getRooms() ?? []
        
        let buttonImageFilled = #imageLiteral(resourceName: "star-filled")
        let buttonImageClear = #imageLiteral(resourceName: "star-empty")
        
        
        favoriteState = false
        for room in rooms{
            if room == self.currentRoomName{
                favoriteButton.setImage(buttonImageFilled, for: .normal)
                favoriteState = true
                break
            }
        }
        
        favoriteButton.setImage(favoriteState ?buttonImageFilled : buttonImageClear, for: .normal)
    }
    
    /*
     Is triggered, when the user presses the favorite button
     in the popup view. Depending on its state is the room
     either added or dismissed from the favorites list.
    */
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let favService = RestFavoritesService()
        var operation: String
        
        if(favoriteState){
            //Remove from favorites
            operation = "DELETE"
        }
        else{
            //Add to favorites
            operation = "PUT"
        }
        
        
        let result = favService.editRooms(roomNumber: self.currentRoomName!, operation: operation)
        
        if(result){
            print("Operation \(operation) was successful on Room \(String(describing: self.currentRoomName))")
            reloadFavoriteButtonState()
        }
        else{
            print("Operation \(operation) was not successful on Room \(String(describing: self.currentRoomName))")
        }
        
        print("AddFav result: \(result.description)")
    }
    
    /*
     Opens the popup with an animation
    */
    func animateIn(){
        
        self.view.addSubview(bookingDetailsView)
        bookingDetailsView.center = self.view.center
        
        bookingDetailsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        bookingDetailsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.bookingDetailsView.alpha = 1
            self.bookingDetailsView.transform = CGAffineTransform.identity
        }
        
        
        self.currentSlot = findCurrentSlot()
        
        self.pickerData.removeAll()
        
        //Displays possible slots in UIPicker
        if (self.currentSlot >= 0){
            for slot in slotsBegin[currentSlot...] {
                self.pickerData.append(getStringTime(from: slot))
            }
        }
        else{
            //TODO change to no display or invisible UIPicker instead
            self.pickerData = ["no empty slot available"]
        }
        
        initialPickerViewState()
        reloadFavoriteButtonState()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.reloadAllComponents()
    }
    
    
    /*
     Closed the popup with an animation.
    */
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.bookingDetailsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.bookingDetailsView.alpha = 0
            
            self.visualEffectView.effect = nil
        }) { (sucess:Bool) in
            self.bookingDetailsView.removeFromSuperview()
        }
    }
    
    /*
     Called if the AR book button is pressed
     */
    @IBAction func showBookingDetailsView(_ sender: UIButton) {
        animateIn()
    }
    
    /*
     Called if the book/cancel button of popupview is pressed
     */
    @IBAction func dissmissPopup(_ sender: Any) {
        animateOut()
        
        //Book the current selected slot and room
        if(currentSlotFree){
            print("Selected Index\(selectedIndex), Current Slot: \(currentSlot)")
            print("\(selectedIndex+currentSlot) has Value: \(slotsBegin[selectedIndex+currentSlot])")
            
            let start = getStartDate(index: self.currentSlot + self.selectedIndex)
            let end = getEndDate(index: self.currentSlot + self.selectedIndex)
            
            let startStr = getStringTime(from: start)
            let endStr = getStringTime(from: end)
            
            let reservations = RestReservationService()
            
            let dateStr = getStringDate(from: Date())
            
            print("Buche Raum: \(self.currentRoomName!) at date \(dateStr) from \(startStr) to \(endStr) with Note Test")
            
            
            let result = reservations.bookRoom(roomNumber: self.currentRoomName!, date: getStringDate(from: Date()), fromTime: startStr, toTime: endStr, reservationNote: "Test")
            
            
            if(result?.success! ?? false){
                print("Room was booked")
                self.view.showToast(toastMessage: "Room \(String(describing: self.currentRoomName)) was booked in time \(startStr) to \(endStr)", duration: 6)
                reloadPlane(color: .red)

            }
            else{
                print("Room couldn't be booked")
                self.view.showToast(toastMessage: "Room \(String(describing: self.currentRoomName)) could not be booked in time \(startStr) to \(endStr)", duration: 6)

            }
        }
        //Try to cancel the current reservation on the current slot and room
        else{
            print("Selected Index\(selectedIndex), Current Slot: \(currentSlot)")
            print("\(selectedIndex+currentSlot) has Value: \(slotsBegin[selectedIndex+currentSlot])")
            
            let start = getStartDate(index: self.currentSlot + self.selectedIndex)
            let end = getEndDate(index: self.currentSlot + self.selectedIndex)
            
            let startStr = getStringTime(from: start)
            let endStr = getStringTime(from: end)
            
            let reservations = RestReservationService()
            
            let dateStr = getStringDate(from: Date())
            
            print("Storniere Raum: \(self.currentRoomName!) at date \(dateStr) from \(startStr) to \(endStr) with Note Test")
            
            let result = reservations.cancelRoom(roomNumber: self.currentRoomName!, date: getStringDate(from: Date()), fromTime: startStr, toTime: endStr)
            
            
            if(result?.success! ?? false){
                print("Room was canceled")
                self.view.showToast(toastMessage: "Room \(String(describing: self.currentRoomName)) was canceled in time \(startStr) to \(endStr)", duration: 6)
                reloadPlane(color: .green)
            }
            else{
                print("Room couldn't be canceled")
                self.view.showToast(toastMessage: "Room \(String(describing: self.currentRoomName)) could not be canceled in time \(startStr) to \(endStr)", duration: 6)
            }
        }
        
 
    }
    
    /*
     Called if the cancel button in the popup is pressed.
     Cancel without doing anything.
     */
    @IBAction func cancelPopup(_ sender: UIButton) {
        animateOut()
    }
    
    
    //MARK: UIPickerDelegate
    
    /*
     Tells the pickerView how many Componets shall be displayed.
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
     Tells the pickerView how mans rows it should display.
    */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    /*
     Connects the pickerView to its data-source.
     In our case it uses the pickerData Array.
    */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    var currentSlotFree = false
    
    /*
     Data selected by the user, preresented by an index.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
        
        let startDate = getStartDate(index: self.currentSlot + row)
        let endDate = getEndDate(index: self.currentSlot + row)
        
        if currentRoom.isAvailable(startDate, endDate){
            self.currentSlotFree = true
            fromTime.text = getStringTime(from: endDate)
            fromTime.textColor = UIColor.black
            //bookButton.isHidden = false
            //TODO add translation
            bookButton.setTitle("book", for: .normal)
        }else{
            self.currentSlotFree = false
            fromTime.text = "Belegt!"
            fromTime.textColor = UIColor.red
            //bookButton.isHidden = true
            //TODO add translation
            bookButton.setTitle("cancel", for: .normal)
        }
        
    }
    
    /*
     Checks if the inital state (index zero chosen by the
     pickerView) is free or not. Therefor it isn't
     needed to choose another value for the pickerview
     to block if the room is not free.
    */
    func initialPickerViewState(){
        if currentSlot == -1 {
            return
        }
        
        let start = getStartDate(index: self.currentSlot)
        let end = getEndDate(index: self.currentSlot)
        if currentRoom.isAvailable(start, end){
            self.currentSlotFree = true
            fromTime.text = getStringTime(from: end)
            fromTime.textColor = UIColor.black
            //bookButton.isHidden = false
            //TODO add translation
            bookButton.setTitle("book", for: .normal)
        }else{
            self.currentSlotFree = false
            fromTime.text = "Belegt!"
            fromTime.textColor = UIColor.red
            //bookButton.isHidden = true
            bookButton.setTitle("cancel", for: .normal)
        }
    }
    
    
}

extension Date {
    func compareTimeOnly(to: Date) -> ComparisonResult {
        var calendar = Calendar.current
        
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let componentsRight = calendar.dateComponents([.hour, .minute, .second], from: to)
        let componentsLeft = calendar.dateComponents([.hour, .minute, .second], from: self)
        
        let hourDiff = componentsRight.hour! - componentsLeft.hour!
        let minuteDiff = componentsRight.minute! - componentsLeft.minute!
        let secondDiff = componentsRight.second! - componentsLeft.second!
        
        let seconds = (( hourDiff ) * 60 + (minuteDiff) ) * 60 + ( secondDiff )
        if seconds == 0 {
            return .orderedSame
        } else if seconds > 0 {
            // Ascending means before
            return .orderedAscending
        } else {
            // Descending means after
            return .orderedDescending
        }
    }
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: self)
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension CGFloat {
    var swf: Float { return Float(self) }
}

//MARK: Add Toast method function in UIView Extension so can use in whole project.
extension UIView
{
    func showToast(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            })
            bgView.removeFromSuperview()
        })
    }
}
extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}

//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

extension UILabel
{
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
}

