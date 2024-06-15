//
//  ApplicationCoordionator.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation
import UIKit
import Combine

class ApplicationCoordionator: Coordinator {
    
    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        AuthenticationManager.shared.checkAuthentication()
        
        AuthenticationManager.shared.isAuthenticated
//            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
            guard let self else { return }
                DispatchQueue.main.async {
                    if isAuthenticated {
                        print("We are authenticated")
                        let mainCoordinator = MainCoordinator()
                        mainCoordinator.start()
                        self.childCoordinators = [mainCoordinator]
                        self.window.rootViewController = mainCoordinator.rootViewController
                    } else {
                        print("We are not authenticated")
                        let authCoordinator = AuthCoordinator()
                        authCoordinator.start()
                        self.childCoordinators = [authCoordinator]
                        self.window.rootViewController = authCoordinator.rootViewControler
                    }
                }
        }.store(in: &subscriptions)
    }
}
