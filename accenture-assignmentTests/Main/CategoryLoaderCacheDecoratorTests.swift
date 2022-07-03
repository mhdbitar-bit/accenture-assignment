@testable import accenture_assignment
import XCTest

protocol CategoryCache {
    typealias SaveResult = Error?
    
    func save(_ categories: [CategoryItem], completion: @escaping (SaveResult) -> Void)
}

final class CategoryLoaderCacheDecorator: CategoryLoader {
    private let decoratee: CategoryLoader
    private let cache: CategoryCache
    
    init(decoratee: CategoryLoader, cache: CategoryCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        decoratee.load { [weak self] result in
            self?.cache.save((try? result.get()) ?? []) { _ in }
            completion(result)
        }
    }
}

final class CategoryLoaderCacheDecoratorTests: XCTestCase, CategoryLoaderTestCase {
    
    func test_load_deliversCategoriesOnLoaderSuccess() {
        let categories = uniqueCategoriesModel()
        let sut = makeSUT(loaderResult: .success(categories))
        
        expect(sut, toCompleteWith: .success(categories))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_load_cahcesLoadedCategoriesOnLoaderSuccess() {
        let cache = CacheSpy()
        let categories = uniqueCategoriesModel()
        let sut = makeSUT(loaderResult: .success(categories), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [.save(categories)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loaderResult: LoadCategoryResult, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> CategoryLoader {
        let loader = CategoryLoaderStub(result: loaderResult)
        let sut = CategoryLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeacks(loader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
    
    private class CacheSpy: CategoryCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save([CategoryItem])
        }
        
        func save(_ categories: [CategoryItem], completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(categories))
            completion(.none)
        }
    }
}
