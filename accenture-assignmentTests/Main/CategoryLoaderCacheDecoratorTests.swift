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

final class CategoryLoaderCacheDecoratorTests: XCTestCase {
    
    func test_load_deliversCategoriesOnLoaderSuccess() {
        let categories = uniqueCategories()
        let loader = CategoryLoaderStub(result: .success(categories))
        let sut = CategoryLoaderCacheDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .success(categories))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let loader = CategoryLoaderStub(result: .failure(anyNSError()))
        let sut = CategoryLoaderCacheDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    // MARK: - Helpers
    
    private func expect(_ sut: CategoryLoader, toCompleteWith expectedResult: LoadCategoryResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedCategories), .success(expectedCategories)):
                XCTAssertEqual(receivedCategories, expectedCategories, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func uniqueCategories() -> [CategoryItem] {
        return [CategoryItem(id: 0, name: "a name")]
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
