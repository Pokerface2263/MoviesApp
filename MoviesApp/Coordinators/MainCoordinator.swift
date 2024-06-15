//
//  MainCoordinator.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var rootViewController: UITabBarController
    
    var childCoordinators = [Coordinator]()
    
    init() {
        self.rootViewController = UITabBarController()
        rootViewController.tabBar.tintColor = Constants.Colors.orangeColor
        rootViewController.tabBar.unselectedItemTintColor = UIColor.white
    }
    
    func start() {
        
        let firstCoordinator = FirstTabCoordinator()
        firstCoordinator.start()
        self.childCoordinators.append(firstCoordinator)
        
        let firstViewController = firstCoordinator.rootViewController
        firstViewController.tabBarItem = UITabBarItem(title: "Main",
                                                      image: UIImage(systemName: "film"),
                                                      selectedImage: UIImage(systemName: "film.fill"))
        
        let secondCoordinator = SecondTabCoordinator()
        secondCoordinator.start()
        self.childCoordinators.append(secondCoordinator)
        
        let secondViewController = secondCoordinator.rootViewControler
        secondViewController.tabBarItem = UITabBarItem(title: "Search",
                                                       image: UIImage(systemName: "safari"),
                                                       selectedImage: UIImage(systemName: "safari.fill"))
        
        let thirdCoordinator = ThirdTabCoordinator()
        thirdCoordinator.start()
        self.childCoordinators.append(thirdCoordinator)
        
        let thirdController = thirdCoordinator.rootViewControler
        thirdController.tabBarItem = UITabBarItem(title: "Profile",
                                                       image: UIImage(systemName: "person"),
                                                       selectedImage: UIImage(systemName: "person.fill"))
        
        
        
        self.rootViewController.viewControllers = [firstViewController, secondViewController, thirdController]
    }
}
