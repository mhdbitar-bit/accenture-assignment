@testable import accenture_assignment
import XCTest

final class CategoryLoaderWithFallbackCompositeTests: XCTestCase {

    func test_load_deliversPrimaryCategoriesOnPrimaryLoaderSuccess() {
        let primaryCategories = uniqueCategories()
        let fallbackCategries = uniqueCategories()
        let sut = makeSUT(primaryResult: .success(primaryCategories), fallbackResult: .success(fallbackCategries))
        
        expect(sut, toCompleteWith: .success(primaryCategories))
    }
    
    func test_load_deliversFallbackCategoriesOnPrimaryFailure() {
        let fallbackCategries = uniqueCategories()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackCategries))
        
        expect(sut, toCompleteWith: .success(fallbackCategries))
    }
    
    func test_load_deliversErrorOnPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    private func makeSUT(primaryResult: LoadCategoryResult, fallbackResult: LoadCategoryResult, file: StaticString = #file, line: UInt = #line) -> CategoryLoader {
        let primaryLoader = LoaderStub(result: primaryResult)
        let fallbackLoader = LoaderStub(result: fallbackResult)
        let sut = CategoryLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeacks(primaryLoader, file: file, line: line)
        trackForMemoryLeacks(fallbackLoader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
    
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
    
    private class LoaderStub: CategoryLoader {
        private let result: LoadCategoryResult
        
        init(result: LoadCategoryResult) {
            self.result = result
        }
        
        func load(completion: @escaping (LoadCategoryResult) -> Void) {
            completion(result)
        }
    }
}
