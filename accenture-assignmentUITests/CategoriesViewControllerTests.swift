@testable import accenture_assignment
import XCTest
import UIKit

class CategoriesViewController: UIViewController {
    private var loader: CategoriesViewControllerTests.LoaderSpy?
         
    convenience init(loader: CategoriesViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load()
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
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }
}
