@testable import accenture_assignment
import XCTest
import UIKit

final class BooksTableViewControllerTests: XCTestCase {

    func test_loadCategoriesActions_requestBooksFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: BooksTableViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let viewModel = BookViewModel(loader: loader)
        let sut = BooksTableViewController(viewModel: viewModel)
        trackForMemoryLeacks(loader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: BookLoader {
        private var completions = [(LoadBookResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadBookResult) -> Void) {
            completions.append(completion)
        }
        
        func completeCategoriesLoading(with categories: [BookItem] = [], at index: Int = 0) {
            completions[index](.success(categories))
        }
        
        func completeCategoriesWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index](.failure(error))
        }
    }
}
