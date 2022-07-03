@testable import accenture_assignment
import XCTest

final class CategoryLoaderCacheDecorator: CategoryLoader {
    private let decoratee: CategoryLoader
    
    init(decoratee: CategoryLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        decoratee.load(completion: completion)
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
    
    // MARK: - Helpers
    
    private func makeSUT(loaderResult: LoadCategoryResult, file: StaticString = #file, line: UInt = #line) -> CategoryLoader {
        let loader = CategoryLoaderStub(result: loaderResult)
        let sut = CategoryLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeacks(loader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
}
