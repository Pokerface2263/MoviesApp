//
//  ListsTableViewCellViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation

class ListsTableViewCellViewModel {
    
    let description: String
    let favoriteCount, id, itemCount: Int
    let listType, name: String
    
    init(list: ListModel) {
        self.id = list.id
        self.name = list.name
        self.description = list.description
        self.itemCount = list.itemCount
        self.favoriteCount = list.favoriteCount
        self.listType = list.listType
    }
}
