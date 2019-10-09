//
//  TabBarViewController.swift
//  AugmentedHTWSaarEsch
//
//  Created by Nicolas Klein on 02.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate{
    
    var arcontroller: ARViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.delegate = self
        selectedIndex = 0
        
        arcontroller = viewControllers![0] as? ARViewController
        
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        arcontroller?.removeAllNodes(exclude: "currentNode")
        arcontroller?.currentRoomName = nil
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
