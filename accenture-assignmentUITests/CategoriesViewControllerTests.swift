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
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsCategories() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
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
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (LoadCategoryResult) -> Void) {
            loadCallCount += 1
        }
    }
}
