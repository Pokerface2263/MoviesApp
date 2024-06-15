//
//  SecondTabBarCoordinator.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit

class SecondTabCoordinator: Coordinator {
    
    var rootViewControler = UINavigationController()
    
    lazy var searchViewController: SearchViewController = {
        let vc = SearchViewController()
        vc.title = "Search"
        return vc
    }()
    
    func start() {
        rootViewControler.setViewControllers([searchViewController], animated: false)
    }
}
