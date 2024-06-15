//
//  AuthViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation
import UIKit
import SafariServices
import Combine

enum AuthError: Error {
    case cannotCreateToken
    case otherError
}

class AuthViewModel {
    
    var subscriptions = Set<AnyCancellable>()
    
    func signIn() -> Future<URL?, AuthError>{
        
        return Future { promise in
            
            APICaller.createRequestToken().sink { isCreated in
                switch isCreated {
                case .finished:
                    print("Token is created")
                case .failure(let error):
                    print("Token is not created! \(error)")
                    promise(.failure(.otherError))
                }
            } receiveValue: { requestToken in
                guard let authorizeURL = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=demoapp://") else {
                    print("Invalid URL or Request Token not fetched")
                    promise(.failure(.cannotCreateToken))
                    return
                }
                print(authorizeURL)
                promise(.success(authorizeURL))
            }.store(in: &self.subscriptions)
        }
    }
    
    func signUp() ->  SFSafariViewController? {
        let signUpURLString = "https://www.themoviedb.org/signup"
        guard let signUpURL = URL(string: signUpURLString) else { return nil }
        
        let safariViewController = SFSafariViewController(url: signUpURL)
        return safariViewController
    }
    
    func openURLInViewController(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL")
        }
    }
}
