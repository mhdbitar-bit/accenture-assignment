@testable import accenture_assignment
import XCTest

final class CategoryLoaderWithFallbackCompositeTests: XCTestCase, CategoryLoaderTestCase {

    func test_load_deliversPrimaryCategoriesOnPrimaryLoaderSuccess() {
        let primaryCategories = uniqueCategoriesModel()
        let fallbackCategries = uniqueCategoriesModel()
        let sut = makeSUT(primaryResult: .success(primaryCategories), fallbackResult: .success(fallbackCategries))
        
        expect(sut, toCompleteWith: .success(primaryCategories))
    }
    
    func test_load_deliversFallbackCategoriesOnPrimaryFailure() {
        let fallbackCategries = uniqueCategoriesModel()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackCategries))
        
        expect(sut, toCompleteWith: .success(fallbackCategries))
    }
    
    func test_load_deliversErrorOnPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    private func makeSUT(primaryResult: LoadCategoryResult, fallbackResult: LoadCategoryResult, file: StaticString = #file, line: UInt = #line) -> CategoryLoader {
        let primaryLoader = CategoryLoaderStub(result: primaryResult)
        let fallbackLoader = CategoryLoaderStub(result: fallbackResult)
        let sut = CategoryLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeacks(primaryLoader, file: file, line: line)
        trackForMemoryLeacks(fallbackLoader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
}
