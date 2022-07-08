@testable import accenture_assignment
import XCTest
import UIKit

final class BooksTableViewControllerTests: XCTestCase {

    func test_loadBooksActions_requestBooksFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadBooksActions_isVisibleWhileLoadingBooks() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeBooksLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfuly")
        
        sut.simulateUserInitiatedResourceReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeBooksWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadBooksCompletion_rendersSuccessfullyloadedBooks() {
        let book1 = makeBook()
        let book2 = makeBook(
            name: "another name",
            isbn: "another isbn",
            numberOfPages: 100,
            country: "another country",
            publisher: "another publisher",
            mediaType: "another media",
            released: "1999-02-02T00:00:00",
            authors: ["another author"]
        )
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeBooksLoading(with: [book1], at: 0)
        assertThat(sut, isRendering: [book1])
        
        sut.simulateUserInitiatedResourceReload()
        loader.completeBooksLoading(with: [book1, book2], at: 1)
        assertThat(sut, isRendering: [book1, book2])
    }
    
    func test_loadBooksCompletion_doesNotAlertCurrentRenderingStateOnError() {
        let book1 = makeBook()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBooksLoading(with: [book1], at: 0)
        assertThat(sut, isRendering: [book1])
        
        sut.simulateUserInitiatedResourceReload()
        loader.completeBooksWithError(at: 1)
        assertThat(sut, isRendering: [book1])
    }
    
    func test_loadBooksCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeBooksLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
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
    
    private func assertThat(_ sut: BooksTableViewController, isRendering books: [BookItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedResourceViews() == books.count else {
            return XCTFail("Expected \(books.count) categories, got \(sut.numberOfRenderedResourceViews()) instead", file: file, line: line   )
        }
        
        books.enumerated().forEach { index, category in
            assertThat(sut, hasViewConfiguredFor: category, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: BooksTableViewController, hasViewConfiguredFor book: BookItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.view(at: index) as? BookTableViewCell
        
        guard let cell = view else {
            return XCTFail("Expected \(UITableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.bookTitleLabel.text, book.name, "Expected name text to be \(String(describing: book.name)) for book view at index \(index)", file: file, line: line)
        
        let formatter = ListFormatter()
        if let authors = formatter.string(from: book.authors) {
            XCTAssertEqual(cell.authorLabel.text, authors, "Expected author text to be \(String(describing: authors)) for book view at index \(index)", file: file, line: line)
        } else {
            let authorLabelText = cell.authorLabel.text ?? ""
            XCTAssertTrue(authorLabelText.isEmpty, "Expected author text to be empty")
        }
        
        XCTAssertEqual(cell.noPagesLabel.text, "\(book.numberOfPages)", "Expected number of pages to be \(String(describing: book.numberOfPages)) for book view at index \(index)", file: file, line: line)
    }
    
    private func makeBook(name: String = "a name", isbn: String = "a isbn", numberOfPages: Int = 0, country: String = "a country", publisher: String = "a publisher", mediaType: String = "a media type", released: String = "1996-08-01T00:00:00", authors: [String] = ["an author"]) -> BookItem {
        return BookItem(
            name: name,
            isbn: isbn,
            numberOfPages: numberOfPages,
            country: country,
            publisher: publisher,
            mediaType: mediaType,
            released: released,
            authors: authors)
    }

    
    class LoaderSpy: BookLoader {
        private var completions = [(LoadBookResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadBookResult) -> Void) {
            completions.append(completion)
        }
        
        func completeBooksLoading(with books: [BookItem] = [], at index: Int = 0) {
            completions[index](.success(books))
        }
        
        func completeBooksWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index](.failure(error))
        }
    }
}
