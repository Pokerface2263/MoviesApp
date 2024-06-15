//
//  TrendingMovieModel.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation

struct TrendingMovieModel: Decodable {
    let backdropPath: String?
    let id: Int
    let title: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let name: String?
    let originalName, firstAirDate: String?
}
