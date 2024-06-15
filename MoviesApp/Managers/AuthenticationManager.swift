//
//  AuthManager.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import Combine

class AuthenticationManager {
    static let shared = AuthenticationManager()

    let isAuthenticated = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()

    private init() { }
    
    func authentication(requestToken: String) {
        
        APICaller.createSessionID(requestToken: requestToken).sink { isCreated in
            switch isCreated {
            case .finished:
                print("Session ID is created")
            case .failure(let error):
                print(error)
            }
        } receiveValue: { sessionID in
            APICaller.getAccountDetails(sessionID: sessionID).sink { isReceived in
                switch isReceived {
                case .finished:
                    print("Accound details is received")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { accountDetails in
                print("We are authenticated")
                self.isAuthenticated.send(true)
                KeychainManager.shared.saveCredentials(requestToken: requestToken, sessionID: sessionID, accountDetails: accountDetails)
                
                let credentials = KeychainManager.shared.getCredentials()
                print("Request Token: \(credentials.requestToken ?? "N/A")")
                print("Session ID: \(credentials.sessionID ?? "N/A")")
                print("Account Details id: \(credentials.accountDetails?.id)")
                print("Account Details username: \(credentials.accountDetails?.username)")

            }.store(in: &self.subscriptions)
        }.store(in: &subscriptions)
    }
    
    func checkAuthentication() {
        let credentials = KeychainManager.shared.getCredentials()

        if let _ = credentials.requestToken,
           let _ = credentials.sessionID,
           let _ = credentials.accountDetails {
            isAuthenticated.send(true)
        } else {
            isAuthenticated.send(false)
        }
    }
}
