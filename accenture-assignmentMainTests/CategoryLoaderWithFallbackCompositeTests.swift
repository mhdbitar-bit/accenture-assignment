@testable import accenture_assignment
import XCTest

class CategoryLoaderWithFallbackComposite: CategoryLoader {
    private let primary: CategoryLoader
    
    init(primary: CategoryLoader, fallback: CategoryLoader) {
        self.primary = primary
    }
    
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        primary.load(completion: completion)
    }
}

final class CategoryLoaderWithFallbackCompositeTests: XCTestCase {

    func test_load_deliversPrimaryCategoriesOnPrimaryLoaderSuccess() {
        let primaryCategories = uniqueCategories()
        let fallbackCategries = uniqueCategories()
        let sut = makeSUT(primaryResult: .success(primaryCategories), fallbackResult: .success(fallbackCategries))
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedCategories):
                XCTAssertEqual(receivedCategories, primaryCategories)
                
            case .failure:
                XCTFail("Expected successful load categoreis result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
    
    private func uniqueCategories() -> [CategoryItem] {
        return [CategoryItem(id: 0, name: "a name")]
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
