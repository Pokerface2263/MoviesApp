//
//  ListCollectionViewCellViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation

class ListCollectionViewCellViewModel {
    
    var id: Int
    var title: String
    var date: String
    var imageUrl: String?
    
    init(movie: TrendingMovieModel) {
        self.id = movie.id
        self.title = movie.title ?? movie.name ?? ""
        self.date = movie.releaseDate ?? movie.firstAirDate ?? ""
        self.imageUrl = movie.posterPath
    }
}
