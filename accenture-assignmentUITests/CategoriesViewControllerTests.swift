@testable import accenture_assignment
import XCTest
import UIKit

final class CategoriesViewControllerTests: XCTestCase {

    func test_loadCategoriesActions_requestCategoreisFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingCategoriesActions_isVisibleWhileLoadingCategories() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeCategoriesLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfuly")
        
        sut.simulateUserInitiatedResourceReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeCategoriesWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
        
    }
    
    func test_loadCategoriesCompletion_rendersSuccessfullyloadedCategories() {
        let cat1 = makeCategory(id: 0, name: "a name")
        let cat2 = makeCategory(id: 1, name: "another name")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeCategoriesLoading(with: [cat1], at: 0)
        assertThat(sut, isRendering: [cat1])
        
        sut.simulateUserInitiatedResourceReload()
        loader.completeCategoriesLoading(with: [cat1, cat2], at: 1)
        assertThat(sut, isRendering: [cat1, cat2])
    }
    
    func test_loadCategoriesCompletion_doesNotAlertCurrentRenderingStateOnError() {
        let cat1 = makeCategory()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCategoriesLoading(with: [cat1], at: 0)
        assertThat(sut, isRendering: [cat1])
        
        sut.simulateUserInitiatedResourceReload()
        loader.completeCategoriesWithError(at: 1)
        assertThat(sut, isRendering: [cat1])
    }
    
    func test_loadCategoriesCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeCategoriesLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(onSelect: ((CategoryItem) -> Void)? = nil, file: StaticString = #filePath, line: UInt = #line) -> (sut: CategoriesViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let viewModel = CategoryViewModel(loader: MainQueueDispatchDecorator(decoratee: loader))
        let sut = CategoriesViewController(viewModel: viewModel, onSelect: onSelect)
        trackForMemoryLeacks(loader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: CategoriesViewController, isRendering categories: [CategoryItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedResourceViews() == categories.count else {
            return XCTFail("Expected \(categories.count) categories, got \(sut.numberOfRenderedResourceViews()) instead", file: file, line: line   )
        }
        
        categories.enumerated().forEach { index, category in
            assertThat(sut, hasViewConfiguredFor: category, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: CategoriesViewController, hasViewConfiguredFor cateogry: CategoryItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.view(at: index)
        
        guard let cell = view else {
            return XCTFail("Expected \(UITableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.nameText, cateogry.name, "Expected name  text to be \(String(describing: cateogry.name)) for category view at index \(index)", file: file, line: line)
    }
    
    class LoaderSpy: CategoryLoader {
        private var completions = [(LoadCategoryResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadCategoryResult) -> Void) {
            completions.append(completion)
        }
        
        func completeCategoriesLoading(with categories: [CategoryItem] = [], at index: Int = 0) {
            completions[index](.success(categories))
        }
        
        func completeCategoriesWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index](.failure(error))
        }
    }
}



private extension UITableViewCell {
    var nameText: String {
        return textLabel?.text ?? ""
    }
}
