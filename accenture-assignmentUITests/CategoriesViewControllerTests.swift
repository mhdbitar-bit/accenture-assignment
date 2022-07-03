@testable import accenture_assignment
import XCTest
import UIKit

class CategoriesViewController: UITableViewController {
    private var loader: CategoryLoader?
         
    convenience init(loader: CategoryLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class CategoriesViewControllerTests: XCTestCase {

    func test_loadCategoriesActions_requestCategoreisFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedCategoriesReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedCategoriesReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingCategoriesActions_isVisibleWhileLoadingCategories() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeCategoriesLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedCategoriesReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeCategoriesLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CategoriesViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CategoriesViewController(loader: loader)
        trackForMemoryLeacks(loader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: CategoryLoader {
        private var completions = [(LoadCategoryResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadCategoryResult) -> Void) {
            completions.append(completion)
        }
        
        func completeCategoriesLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension CategoriesViewController {
    func simulateUserInitiatedCategoriesReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { (target as NSObject).perform(Selector($0))
            }
        }
    }
}
