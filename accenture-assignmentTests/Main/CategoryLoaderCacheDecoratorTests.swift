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
        let loader = CategoryLoaderStub(result: .success(categories))
        let sut = CategoryLoaderCacheDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .success(categories))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let loader = CategoryLoaderStub(result: .failure(anyNSError()))
        let sut = CategoryLoaderCacheDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
}
