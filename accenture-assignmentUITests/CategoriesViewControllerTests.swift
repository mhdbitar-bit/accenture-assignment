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
        refreshControl?.beginRefreshing()
        load()
    }
    
    @objc private func load() {
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class CategoriesViewControllerTests: XCTestCase {

    func test_init_doesNoLoadCategories() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsCategories() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_userInitiatedCategoriesReload_loadsCategories() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedCategoriesReload()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserInitiatedCategoriesReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_viewDidLoad_showLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isShowingloadingIndicator)
    }
    
    func test_viewDidLoad_hideLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCategoriesLoading()
        
        XCTAssertFalse(sut.isShowingloadingIndicator)
    }
    
    func test_userInitiatedCategoriesReload_showLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.simulateUserInitiatedCategoriesReload()
        
        XCTAssertTrue(sut.isShowingloadingIndicator)
    }
    
    func test_userInitiatedCategoriesReload_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.simulateUserInitiatedCategoriesReload()
        loader.completeCategoriesLoading()
        
        XCTAssertFalse(sut.isShowingloadingIndicator)
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
        
        func completeCategoriesLoading() {
            completions[0](.success([]))
        }
    }
}

private extension CategoriesViewController {
    func simulateUserInitiatedCategoriesReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingloadingIndicator: Bool {
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
