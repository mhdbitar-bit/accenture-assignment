//
//  MainQueueDispatchDecorator.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: CategoryLoader where T == CategoryLoader {
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
