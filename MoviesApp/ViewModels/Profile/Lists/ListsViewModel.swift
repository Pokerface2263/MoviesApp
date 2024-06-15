//
//  ListsViewModel.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation
import UIKit
import Combine

class ListsViewModel {
    
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var cellDataSource: Obsorvable<[ListsTableViewCellViewModel]> = Obsorvable(nil)
    var dataSources: [ListModel] = []
    
    var subscriptions = Set<AnyCancellable>()
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int = 1) -> Int {
        return dataSources.count
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        
        let name = dataSources[indexPath.row].name
        let description = dataSources[indexPath.row].description
        
        print(name)
        print(description)
        
        let nameHeight = heightForLabel(text: name, fontSize: 20)
        let descriptionHeight = heightForLabel(text: description, fontSize: 14)
        
        return nameHeight + descriptionHeight
    }
    
    func heightForLabel(text: String, fontSize: CGFloat) -> CGFloat {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.sizeToFit()
        return textView.frame.height
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({ListsTableViewCellViewModel(list: $0)})
    }
    
    func getData() {
        
        if self.isLoading.value ?? true {
            return
        }
        
        self.isLoading.value = true
        let credentials = KeychainManager.shared.getCredentials()
        guard let accountID = credentials.accountDetails?.id,
        let sessionID = credentials.sessionID else {
            self.isLoading.value = false
            return
        }
        
        APICaller.getLists(accountID: accountID, sessionID: sessionID)
            .sink { isReceived in
                switch isReceived {
                case .finished:
                    print("Lists are received")
                case .failure(let error):
                    print("Lists are not received. Error: \(error)")
                }
            } receiveValue: { lists in
                if let lists {
                    self.isLoading.value = false
                        
                    self.dataSources.append(contentsOf: lists)
                    self.mapCellData()
                } else {
                    return
                }
            }.store(in: &self.subscriptions)
    }
}
