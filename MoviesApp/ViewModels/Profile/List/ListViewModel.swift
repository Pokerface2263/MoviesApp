//
//  ListViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit
import Combine

class ListViewModel {
    
    var listID: Int?

    var selectedContentType: ListContentType = .movies
    var typeOfList: Obsorvable<ListType> = Obsorvable(nil)
    var cellDataSource: Obsorvable<[ListCollectionViewCellViewModel]> = Obsorvable(nil)
    var dataSources: [TrendingMovieModel] = []
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    
    var subscriptions = Set<AnyCancellable>()
    
    
    func getData(completion: ((Result<Void, APICallerEror>) -> Void)? = nil) {
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = true
        let credentials = KeychainManager.shared.getCredentials()
        guard let accountID = credentials.accountDetails?.id,
        let sessionID = credentials.sessionID else {
            completion?(.failure(.cannotGetCredentials))
            return
        }
        
        
        switch typeOfList.value {
        case .favorite:
            APICaller.getAccountMovies(accountID: accountID, sessionID: sessionID, listType: "favorite", contentType: selectedContentType)
                .sink { isReceived in
                    switch isReceived {
                    case .finished:
                        print("Favorite movie/tv is received")
                    case .failure(let error):
                        print("Favorite movie/tv receiving is failed with error: \(error)")
                    }
            } receiveValue: { [weak self] data in
                self?.isLoading.value = false
                if let data {
                    self?.dataSources = data
                    self?.mapCellData()
                }
            }.store(in: &subscriptions)
        case .watchlist:
            APICaller.getAccountMovies(accountID: accountID, sessionID: sessionID, listType: "watchlist", contentType: selectedContentType)
                .sink { isReceived in
                    switch isReceived {
                    case .finished:
                        print("Watchlist movie/tv is received")
                    case .failure(let error):
                        print("Watchlist movie/tv receiving is failed with error: \(error)")
                    }
            } receiveValue: { [weak self] data in
                self?.isLoading.value = false
                if let data {
                    self?.dataSources = data
                    self?.mapCellData()
                }
            }.store(in: &subscriptions)
        default:
            print("Error with \(selectedContentType.rawValue)")
        }
        
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({ListCollectionViewCellViewModel(movie: $0)})
    }
    
    func getSizeForItem() -> CGSize {
        let width = UIScreen.main.bounds.size.width / 3.5
        let height = UIScreen.main.bounds.size.height / 5
        return CGSize(width: width, height: height)
    }
    
    func removeData() {
        cellDataSource.value?.removeAll()
        dataSources.removeAll()
    }
}
