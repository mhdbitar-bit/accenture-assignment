//
//  CodableCategoryStore.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class CodeableCategoryStore: CategoryStore {
    private struct Cache: Codable {
        let categories: [CodableCategories]
        let timestamp: Date
        
        var localCategories: [LocalCategoryItem] {
            return categories.map { $0.local }
        }
    }
    
    private struct CodableCategories: Codable {
        private let id: Int
        private let name: String
        
        init(_ category: LocalCategoryItem) {
            id = category.id
            name = category.name
        }
        
        var local: LocalCategoryItem {
            return LocalCategoryItem(id: id, name: name)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodeableCategoryStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(categories: cache.localCategories, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func insert(_ categories: [LocalCategoryItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(categories: categories.map(CodableCategories.init), timestamp: timestamp)
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func deleteCachedCategories(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
