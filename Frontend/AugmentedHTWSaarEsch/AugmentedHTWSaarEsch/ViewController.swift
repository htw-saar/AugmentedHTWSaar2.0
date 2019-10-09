//
//  ViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christian Herz, Philipp Kügler on 13.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import UIKit
import ARKit
//import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    //Klassen Konstanten
    let ARScene = SCNScene()
    let brett = Brett()
    var user = User()
    let restSchnittstelleRaum = RestSchnittstelleRaum()
    var raum = Raum()
    
    //Klassen Varaiablen
    var keinBrettAngezeigt: Bool  = true
    @IBOutlet weak var ARView: ARSCNView! 
    @IBOutlet weak var btnVersteckeBtnView: UIButton!
    @IBOutlet weak var btnSprechzeiten: UIButton!
    @IBOutlet weak var viewFuerButtons: UIView!
    @IBOutlet weak var btnZeigeBtnView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARView.delegate = self
        ARView.session.delegate = self
        ARView.autoenablesDefaultLighting = true
        ARView.automaticallyUpdatesLighting = true
        ARView.scene = ARScene
        
        print("yah")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //May be changed to ARImagetrackingConfiguration
        //Could be changed dy
        let configuartion = ARWorldTrackingConfiguration()
        //rederer(didAdd:)
        configuartion.planeDetection = .vertical
        //all renderer
        configuartion.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        
        ARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        ARView.session.run(configuartion)
        
        if keinBrettAngezeigt {
            viewFuerButtons.isHidden = true
            btnZeigeBtnView.isHidden = true
            btnVersteckeBtnView.isHidden = true
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //test2()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ARView.session.pause()
    }

    /*
     If a picture form the AR-References is found it updates the node.
     Gets called everytime a picture is found, even the same one.
     Our view gets repositioned all the time, doesn't look that good.
     Better would be to check if the new position is way different and
     only do something then. But its of to check how that can be done.
 
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if true {
            if let imageAnchor = anchor as? ARImageAnchor {
                let name = imageAnchor.referenceImage.name!
                print("you found a \(name) image")
                
                let size = imageAnchor.referenceImage.physicalSize
                let videoNode = makeVideo(size: size)
                node.addChildNode(videoNode)
                node.opacity = 1
                //node.scale = SCNVector3(0.02, 0.02, 0.02)
            }
        }
    }
    */
    
    /*
     If a new Anker for a AR-Reference is found, this method gets called once.
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            let name = imageAnchor.referenceImage.name!
            print("you found a \(name) image")
            
            let size = imageAnchor.referenceImage.physicalSize
            let videoNode = makeVideo(size: size)
            node.addChildNode(videoNode)
            node.opacity = 1
            //node.scale = SCNVector3(0.02, 0.02, 0.02)
        }
    }
    /*
     Gets called if a plane is found somewhere in the viewfinder.
     If thats the case, a coloured simple plane gets added to the found plane.
     >> Only works if no images are searched. Can be fixed by searching for horizontal planes,
        not vertical ones.
 
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        print ("Did enter plane detection renderer")
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = UIColor.green
        
        let planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        
        planeNode.position = SCNVector3(x,y,z)
        
        planeNode.eulerAngles.x = -.pi/2

        node.addChildNode(planeNode)
        node.opacity = 1
     }
    */
    /*
     Adds a playing video if a reference image is found.
    */
    func makeVideo(size: CGSize) -> SCNNode{
        //Initalizes video url for node
        guard let videoURL = Bundle.main.url(forResource: "slovenia",
                                             withExtension: "mp4") else {
                                                print("No Video found!")
                                                return SCNNode()
        }
        
        //Initializes AVPlayer, which plays the video
        let avPlayerItem = AVPlayerItem(url: videoURL)
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        avPlayer.play()
        
        //Player controlls, our video starts from the
        //beginning if the anker is found again
        //(Only with render(didUpdate:) not
        //render(didAdd:)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: nil) { notification in
                avPlayer.seek(to: .zero)
                avPlayer.play()
        }
        
        //Creates an player material
        let avMaterial = SCNMaterial()
        avMaterial.diffuse.contents = avPlayer
        
        //Adds the player material to a plane
        let videoPlane = SCNPlane(width: size.width, height: size.height)
        videoPlane.materials = [avMaterial]
        
        //Adds all the shit to a node like always
        let videoNode = SCNNode(geometry: videoPlane)
        
        //Euler angles change the tilting of the view
        //See picture in project folder for understanding
        videoNode.eulerAngles.x = -90.degreesToRadians.swf
        videoNode.eulerAngles.y = 180.degreesToRadians.swf
        return videoNode
    }
    
    /*
     Generates a node with a simple text
    */
    func makeText(size: CGSize) -> SCNNode{
        let text = SCNText(string: "Hello", extrusionDepth: 0.9)
        text.materials.first?.diffuse.contents = UIColor.green
        let textNode = SCNNode(geometry: text)
        //textNode.position = SCNVector3(0.5,0.5,-1)
        textNode.eulerAngles.x = 90.degreesToRadians.swf // make text straigth up
        textNode.eulerAngles.z = 90.degreesToRadians.swf // roate it by 180 degrees

        return textNode
    }
    
    /*
     Generates a simple plane and adds it to a node.
     Plane detection planes work way better, but we need the image recognition
     Maybe its possible to fusion both
    */
    func makePlane(size: CGSize) -> SCNNode{
        
        // 5
        let videoPlane = SCNPlane(width: size.width, height: size.height)
        videoPlane.materials.first?.diffuse.contents = UIColor.green
        
        // 6
        let videoNode = SCNNode(geometry: videoPlane)
        videoNode.eulerAngles.x = -.pi / 2
        return videoNode
    }
    /*
     Test function, to get the board to show. Just to grasp understanding for last semesters work.
     */
    func test(){
        zeigeButtons()
        
        let alert = UIAlertController(title: "R808", message: "Zum Schließen lange gedrückt halten", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        keinBrettAngezeigt = false
        
        raum = Raum.init(raumnummer: 1000, verantwortlicher: user, raumartID: nil, raumartBezeichnung: "Spassraum", htwSeite: "www.google.com")
        let planeNode = brett.erzeugeSchwarzesBrett(imageName: "Bla", raum:raum)
        guard let currentFrame = ARView.session.currentFrame else {return}
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1 // entfernung von kamera
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform,translation)
        
        ARScene.rootNode.addChildNode(planeNode)
    }
    
    /*
     This time around we want to play with geometries, materials and nodes,
     to get a grasp of how they work together.
     */
    func test2(){
        let torus = SCNNode(geometry: SCNTorus(ringRadius: 0.05, pipeRadius: 0.03))
        torus.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        torus.geometry?.firstMaterial?.specular.contents = UIColor.red
        torus.position = SCNVector3(0.5, 0, -1)
        torus.eulerAngles.z = 40.degreesToRadians.swf
        
        ARScene.rootNode.addChildNode(torus)
    }
    /*
     Hilfsfunktion zur Implementierung des Slide out Menüs
     */
    func zeigeButtons(){
        DispatchQueue.main.async(execute: { //Sorgt dafür, dass Code im Main Thread ausgeführt wird
            self.btnZeigeBtnView.isHidden = false
        })
    }
    
    /*
     Hilfsfunktion zur Implementierung des Slide out Menüs
     */
    @IBAction func zeigeBtnView(_ sender: Any) {
        self.viewFuerButtons.isHidden = false
        self.btnVersteckeBtnView.isHidden = false
        self.btnZeigeBtnView.isHidden = true
    }
    
    /*
     Hilfsfunktion zur Implementierung des Slide out Menüs
     */
    @IBAction func versteckeBtnView(_ sender: Any) {
        DispatchQueue.main.async(execute: { //Sorgt dafür, dass Code im Main Thread ausgeführt wird
            self.viewFuerButtons.isHidden = true
            self.btnVersteckeBtnView.isHidden = true
            self.btnZeigeBtnView.isHidden = false
        })
    }
    
    // Schliesst das Schwarze Brett
    @IBAction func schliessen(_ sender: Any) {
        keinBrettAngezeigt = true
        ARScene.rootNode.enumerateChildNodes{(planeNode, _) in
            planeNode.removeFromParentNode()
        }
        self.btnZeigeBtnView.isHidden = true
        if !self.viewFuerButtons.isHidden {
            self.viewFuerButtons.isHidden = true
            self.btnVersteckeBtnView.isHidden = true
        }
    }
    
    /*
     Überschreibt die FUnktion prepare und ermöglicht so das weiterleiten der informationen zu user und raum an den
     nächsten View Controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is KontaktViewController)
        {
            let vc = segue.destination as? KontaktViewController
            vc?.user = user
            vc?.raum = raum
        }
        if(segue.destination is SprechzeitenViewController)
        {
            let vc = segue.destination as? SprechzeitenViewController
            vc?.raum = raum
            vc?.user = user
        }
        if(segue.destination is SeiteViewController)
        {
            let vc = segue.destination as? SeiteViewController
            vc?.raum = raum
            vc?.user = user
        }
    }
    
    /*
     Funktion um andere Views zu schliessen (damit nicht der Speicher belastet wird)
     und zur Hauptansicht zurueckzukehren. So muss das Schwarze Brett nicht erneut
     aufgerufen werden
     */
    @IBAction func unwindZurueckZuHauptansicht(sender: UIStoryboardSegue){}
    
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

