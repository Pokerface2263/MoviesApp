//
//  AuthCoordinator.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit

class AuthCoordinator: Coordinator {
    
    var rootViewControler = UINavigationController()
    
    lazy var authViewController: AuthViewController = {
        let vc = AuthViewController()
        vc.title = "Authentication"
        return vc
    }()
    
    func start() {
        rootViewControler.setViewControllers([authViewController], animated: false)
    }
}
