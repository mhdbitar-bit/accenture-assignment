@testable import accenture_assignment
import XCTest
import UIKit

class CategoriesViewController: UIViewController {
    private var loader: CategoryLoader?
         
    convenience init(loader: CategoryLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}

final class CategoriesViewControllerTests: XCTestCase {

    func test_init_doesNoLoadCategories() {
        let loader = LoaderSpy()
        _ = CategoriesViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsCategories() {
        let loader = LoaderSpy()
        let sut = CategoriesViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy: CategoryLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (LoadCategoryResult) -> Void) {
            loadCallCount += 1
        }
    }
}
