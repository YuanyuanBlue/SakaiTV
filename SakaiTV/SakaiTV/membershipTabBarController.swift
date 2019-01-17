//
//  membershipViewController.swift
//  SakaiTV
//
//  Created by tong on 11/3/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

class membershipTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currentcourses = currentcourseTableViewController()
        let baritem1 = UITabBarItem(title: "My Current Sites", image: nil, tag: 1)
        baritem1.titlePositionAdjustment = UIOffset(horizontal: 50, vertical: 0)
        currentcourses.tabBarItem = baritem1
        let allcourses = allcourseTableViewController()
        let baritem2 = UITabBarItem(title: "My Official Couse Enrollments", image: nil, tag: 2)
        baritem2.titlePositionAdjustment = UIOffset(horizontal: 400, vertical: 0)
        allcourses.tabBarItem = baritem2
        let controllers = [currentcourses, allcourses]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("should select \(String(describing: viewController.title))")
        return true
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
