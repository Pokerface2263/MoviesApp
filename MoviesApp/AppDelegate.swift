//
//  AppDelegate.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationCoordinator: ApplicationCoordionator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = Constants.Colors.orangeColor
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let applicationCoordinator = ApplicationCoordionator(window: window)
        
        window.rootViewController = UIViewController()
            
        window.makeKeyAndVisible()
        
        DispatchQueue.main.async {
                applicationCoordinator.start()
        }
        
        self.applicationCoordinator = applicationCoordinator
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        if url.scheme == "demoapp" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems {
                if let requestToken = queryItems.first(where: { $0.name == "request_token" })?.value,
                    let approvedValue = queryItems.first(where: { $0.name == "approved" })?.value,
                    approvedValue.lowercased() == "true" {
                    
                    AuthenticationManager.shared.authentication(requestToken: requestToken)
                    
                } else {
                    AuthenticationManager.shared.isAuthenticated.send(false)
                }
            }
            return true
        }
        return false
    }
}

