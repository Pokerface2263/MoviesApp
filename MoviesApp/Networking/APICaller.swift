//
//  APICaller.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation
import Combine
import UIKit

enum NetworkError: Error {
    case urlError
    case networkError
    case invalidResponce
    case cannotParseData
    case noData
}

enum NetworkPostError: Error {
    case urlError
    case serializationError
    case invalidResponce
    case networkError
    case noData
    case apiError
    case jsonParsingError
}

struct APICaller {
    
    //MARK: - Auth
    
    static func createRequestToken() -> Future<String, NetworkError> {
        
        let urlString = "\(NetworkConstant.shared.serverAddress)authentication/token/new?api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let tokenResponse = try JSONDecoder().decode(RequestToken.self, from: data)
                        print(tokenResponse.requestToken)
                        promise(.success(tokenResponse.requestToken))
                    } catch {
                        promise(.failure(.cannotParseData))
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    //https://api.themoviedb.org/3/authentication/session/new?request_token={request_token}}&api_key={api_key}
    static func createSessionID(requestToken: String) -> Future<String, NetworkError> {
        let urlString = "\(NetworkConstant.shared.serverAddress)authentication/session/new?request_token=\(requestToken)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
//                let requestBody: [String: Any] = [
//                    "api_key": NetworkConstant.shared.apiKey,
//                    "request_token": requestToken
//                ]
                
//                do {
//                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
//                } catch {
//                    promise(.failure(.cannotParseData))
//                    return
//                }
                
                if let data = dataResponse {
                    do {
                        let sessionResponse = try JSONDecoder().decode(SessionID.self, from: data)
                        print(sessionResponse.sessionId)
                        promise(.success(sessionResponse.sessionId))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    static func getAccountDetails(sessionID: String) -> Future<AccountDetails, NetworkError> {
        
        let urlString = "\(NetworkConstant.shared.serverAddress)account?api_key=\(NetworkConstant.shared.apiKey)&session_id=\(sessionID)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
                return
            }
        }
        
        return Future { promise in
            
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let accountDetails = try JSONDecoder().decode(AccountDetails.self, from: data)
                        print(accountDetails.username)
                        promise(.success(accountDetails))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    //MARK: - Trending and search
    
    static func getTrendingMovies(pageNumber: Int = 1, contentType: MainContentType = .all) -> Future<[TrendingMovieModel], NetworkError> {
        
        let urlString = "\(NetworkConstant.shared.serverAddress)trending/\(contentType.rawValue)/day?language=en-US&page=\(pageNumber)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let resultData = try JSONDecoder().decode(TrendingMoviesModel.self, from: data)
                        let movieList = resultData.results.map { model in
                            TrendingMovieModel(backdropPath: model.backdropPath,
                                               id: model.id,
                                               title: model.title,
                                               originalTitle: model.originalName,
                                               overview: model.overview,
                                               popularity: model.popularity,
                                               posterPath: model.posterPath,
                                               releaseDate: model.releaseDate,
                                               voteAverage: model.voteAverage,
                                               voteCount: model.voteCount,
                                               name: model.name,
                                               originalName: model.originalName,
                                               firstAirDate: model.firstAirDate)
                        }
                        promise(.success(movieList))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    static func searchMovieRequest(contentType: SearchContentType, query: String = "") -> Future<[TrendingMovieModel]?, NetworkError> {
        
        let urlString = "\(NetworkConstant.shared.serverAddress)search/\(contentType.rawValue)?query=\(query)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let resultData = try JSONDecoder().decode(TrendingMoviesModel.self, from: data)
                        let movieList = resultData.results.map { model in
                            TrendingMovieModel(backdropPath: model.backdropPath,
                                               id: model.id,
                                               title: model.title,
                                               originalTitle: model.originalName,
                                               overview: model.overview,
                                               popularity: model.popularity,
                                               posterPath: model.posterPath,
                                               releaseDate: model.releaseDate,
                                               voteAverage: model.voteAverage,
                                               voteCount: model.voteCount,
                                               name: model.name,
                                               originalName: model.originalName,
                                               firstAirDate: model.firstAirDate)
                        }
                        promise(.success(movieList))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    //MARK: - Images
    
    static func loadImage(id: String) async -> UIImage? {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + id) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    //MARK: - User lists
    
    //https://api.themoviedb.org/3/account/{account_id}/favorite/movies?session_id={session_id}&api_key={api_key}
    static func getAccountMovies(accountID: Int, sessionID: String, listType: String, contentType: ListContentType) -> Future<[TrendingMovieModel]?, NetworkError> {
        let urlString = "\(NetworkConstant.shared.serverAddress)account/\(accountID)/\(listType)/\(contentType.rawValue)?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let resultData = try JSONDecoder().decode(TrendingMoviesModel.self, from: data)
                        let movieList = resultData.results.map { model in
                            TrendingMovieModel(backdropPath: model.backdropPath,
                                               id: model.id,
                                               title: model.title,
                                               originalTitle: model.originalName,
                                               overview: model.overview,
                                               popularity: model.popularity,
                                               posterPath: model.posterPath,
                                               releaseDate: model.releaseDate,
                                               voteAverage: model.voteAverage,
                                               voteCount: model.voteCount,
                                               name: model.name,
                                               originalName: model.originalName,
                                               firstAirDate: model.firstAirDate)
                        }
                        promise(.success(movieList))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    //https://api.themoviedb.org/3/account/{account_id}/lists?session_id={session_id}&api_key={api_key}
    static func getLists(accountID: Int, sessionID: String) -> Future<[ListModel]?, NetworkError> {
        let urlString = "\(NetworkConstant.shared.serverAddress)account/\(accountID)/lists?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let resultData = try JSONDecoder().decode(ListModelData.self, from: data)
                        let list = resultData.results.map { model in
                            ListModel(description: model.description,
                                                  favoriteCount: model.favoriteCount,
                                                  id: model.id,
                                                  itemCount: model.itemCount,
                                                  listType: model.listType,
                                                  name: model.name)
                        }
                        promise(.success(list))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    //https://api.themoviedb.org/3/list/8288699?session_id={session_id}&api_key={api_key}
    static func getMoviesFromList(listID: Int, sessionID: String) -> Future<[TrendingMovieModel], NetworkError> {
        let urlString = "\(NetworkConstant.shared.serverAddress)list/\(listID)?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.urlError))
            }
        }
        
        return Future { promise in
            
            let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }
                
                if let data = dataResponse {
                    do {
                        let resultData = try JSONDecoder().decode(ListMovieModelData.self, from: data)
                        let movieList = resultData.items.map { model in
                            TrendingMovieModel(backdropPath: model.backdropPath,
                                               id: model.id,
                                               title: model.title,
                                               originalTitle: model.originalTitle,
                                               overview: model.overview,
                                               popularity: model.popularity,
                                               posterPath: model.posterPath,
                                               releaseDate: model.releaseDate,
                                               voteAverage: model.voteAverage,
                                               voteCount: model.voteCount,
                                               name: model.title,
                                               originalName: model.originalTitle,
                                               firstAirDate: model.releaseDate)
                        }
                        promise(.success(movieList))
                    } catch {
                        promise(.failure(.cannotParseData))
                        return
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
    
    //https://api.themoviedb.org/3/account/{account_id}/favorite?session_id={session_id}}&api_key={api_key}
    static func addMovieToFavorite(listType: ListType, mediaType: ListContentType, movieID: Int, accountID: Int, sessionID: String) -> Future<Void, NetworkPostError> {
        
        var listTypeString = ""
        
        switch listType {
        case .favorite:
            listTypeString = "favorite"
        case .watchlist:
            listTypeString = "watchlist"
        }
        
        let urlString = "\(NetworkConstant.shared.serverAddress)account/\(accountID)/\(listTypeString)?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"

        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(.noData))
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["media_type": mediaType.rawValue, "media_id": movieID, listTypeString: true]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            return Future { promise in
                promise(.failure(.serializationError))
            }
        }

        return Future { promise in
            let task = URLSession.shared.dataTask(with: request) { dataResponse, urlResponse, error in
                
                if error != nil {
                    promise(.failure(.networkError))
                    return
                }

                guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(.invalidResponce))
                    return
                }

                if let data = dataResponse {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        if let success = json?["success"] as? Bool, success {
                            promise(.success(()))
                        } else {
                            promise(.failure(.apiError))
                        }
                    } catch {
                        promise(.failure(.serializationError))
                    }
                } else {
                    promise(.failure(.noData))
                }
            }
            
            task.resume()
        }
    }
}
