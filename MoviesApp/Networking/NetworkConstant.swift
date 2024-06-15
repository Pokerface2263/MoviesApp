//
//  NetworkConstants.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation

struct NetworkConstant {
    
    public static var shared: NetworkConstant = NetworkConstant()
    
    private let configDict: [String: Any]?
    
    private init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            configDict = nil
            return
        }
        configDict = NSDictionary(contentsOfFile: path) as? [String: Any]
    }
    
    var apiKey: String {
        guard let apiKey = configDict?["APIKey"] as? String else {
            fatalError("API Key not found in Config.plist")
        }
        return apiKey
    }
    
    var serverAddress: String {
        guard let serverAddress = configDict?["ServerAddress"] as? String else {
            fatalError("Server Address not found in Config.plist")
        }
        return serverAddress
    }
    
    var imageServerAddress: String {
        guard let imageServerAddress = configDict?["ImageServerAddress"] as? String else {
            fatalError("Image Server Address not found in Config.plist")
        }
        return imageServerAddress
    }
}

