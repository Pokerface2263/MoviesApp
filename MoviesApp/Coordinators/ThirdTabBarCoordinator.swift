//
//  ThirdTabBarCoordinator.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit

class ThirdTabCoordinator: Coordinator {
    
    var rootViewControler = UINavigationController()
    
    
    lazy var profileViewController: ProfileViewController = {
        let vc = ProfileViewController()
        vc.title = "Third"
        return vc
    }()
    
    func start() {
        rootViewControler.setViewControllers([profileViewController], animated: false)
    }
}
