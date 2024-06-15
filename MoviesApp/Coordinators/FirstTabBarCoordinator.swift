//
//  FirstTabBarController.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit

class FirstTabCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var mainViewController: MainViewController = {
       let vc = MainViewController()
        vc.title = "Movies"
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([mainViewController], animated: false)
    }
}
