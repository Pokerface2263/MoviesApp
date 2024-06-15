//
//  SearchViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit
import Combine

class SearchViewModel {
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var cellDataSource: Obsorvable<[SearchTableViewCellViewModel]> = Obsorvable(nil)
    var dataSources: [TrendingMovieModel] = []
    var query: Obsorvable<String> = Obsorvable("")
    var contentType: SearchContentType = .tv
    
    var subscriptions = Set<AnyCancellable>()
    
    func getHeightForRow() -> CGFloat {
        return UIScreen.main.bounds.height * 0.1
    }
    
    func getData(completion: ((Result<Void, Error>) -> Void)? = nil) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        
        APICaller.searchMovieRequest(contentType: contentType, query: query.value ?? "")
            .sink { isSearched in
                switch isSearched {
                case .finished:
                    print("Movies is searched")
                case .failure(let error):
                    print("Searching failed with error: \(error)")
                }
        } receiveValue: { [weak self] data in
            if let data {
                self?.isLoading.value = false
                self?.dataSources.append(contentsOf: data)
                self?.mapCellData()
                completion?(.success(()))
            } else {
                completion?(.failure(MyError.genericError("Searching failed with error")))
            }
        }.store(in: &subscriptions)
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({SearchTableViewCellViewModel(movie: $0)})
    }
    
    func getMovieTitle(_ movie: TrendingMovieModel) -> String {
        return movie.title ?? movie.name ?? ""
    }
    
    func retriveMovie(by id: Int) -> TrendingMovieModel? {
        guard let movie = dataSources.first(where: {$0.id == id}) else {
            return nil
        }
        return movie
    }
    
    func removeData() {
        cellDataSource.value?.removeAll()
        dataSources.removeAll()
    }
    
}
