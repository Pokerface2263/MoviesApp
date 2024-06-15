//
//  Observable.swift
//  MoviesApp
//
//  Created by Pokerface on 25.02.2024.
//

import Foundation

class Obsorvable<T> {
    
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init( _ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> ())?
    
    func bind( _ listener: @escaping ((T?) -> ())) {
        listener(value)
        self.listener = listener
    }
}
