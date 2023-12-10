//
//  Utils.swift
//  The iOS Things
//
//  Created by Ariesta APP on 10/12/23.
//

import Foundation
import UIKit

struct Utils {
    static func setupRootTabBarVC(tabBar: UITabBarController) {
        tabBar.viewControllers = [
            Utils().setSingleTabVC(vc: HomeViewController(), tabTitle: "Home", tabIcon: UIImage(), tag: 0),
            
        ]
    }
    private func setSingleTabVC(vc: UIViewController, tabTitle: String, tabIcon: UIImage, tag: Int) -> UIViewController {
        let navVC = UINavigationController(rootViewController: vc)
        navVC.tabBarItem = UITabBarItem(title: tabTitle, image: tabIcon, tag: tag)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationItem.title = tabTitle
        return navVC
    }
}
