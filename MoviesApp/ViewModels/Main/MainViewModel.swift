//
//  MainViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit
import Combine

class MainViewModel {
    
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var cellDataSource: Obsorvable<[MainMovieCellViewModel]> = Obsorvable(nil)
    var dataSources: [TrendingMovieModel] = []
    var pageNumber = 1
    var contentType: MainContentType = .all
    var selectedCell: Int = 0
    var allContentTypes = MediaContentTextType.allCases
    
    var subscriptions = Set<AnyCancellable>()
    
    //TableView
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int = 1) -> Int {
        return dataSources.count
    }
    
    func getHeightForRow() -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    func getData(completion: ((Result<Void, Error>) -> Void)? = nil) {
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = true
        
        APICaller.getTrendingMovies(pageNumber: pageNumber, contentType: contentType)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Trending Movie Fetching is finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] data in
                self?.isLoading.value = false
                self?.dataSources.append(contentsOf: data)
                self?.mapCellData()
            }).store(in: &subscriptions)
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({MainMovieCellViewModel(movie: $0)})
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
    
    //CollectionView
    func isCollectionViewSelected(indexPath: Int) -> Bool {
        if indexPath == selectedCell {
            return true
        }
        return false
    }
    
    func removeDataAfterSelectedCell(contentType: MainContentType) {
        self.contentType = contentType
        cellDataSource.value?.removeAll()
        dataSources.removeAll()
        pageNumber = 1
    }
}

