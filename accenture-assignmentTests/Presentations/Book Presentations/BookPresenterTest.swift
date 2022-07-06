@testable import accenture_assignment
import XCTest

final class BookPresenterTest: XCTestCase {

    func test_map_createsViewModels() {
        let books = uniqueBooks()
        
        let viewModel = BookPresenter.map(books)
        
        XCTAssertEqual(viewModel.books, books)
    }
    
    // MARK: - Hepers
    
    private func uniqueBook(name: String, isbn: String, numberOfPages: Int, country: String, publisher: String, mediaType: String, released: String, authors: [String]) -> BookItem {
        return BookItem(
            name: name,
            isbn: isbn,
            numberOfPages: numberOfPages,
            country: country,
            publisher: publisher,
            mediaType: mediaType,
            released: released,
            authors: authors
        )
    }

    private func uniqueBooks() -> [BookItem] {
        let book1 = uniqueBook(
            name: "a name",
            isbn: "a isbn",
            numberOfPages: 100,
            country: "a country",
            publisher: "a publisher",
            mediaType: "a media type",
            released: "2020-08-28T15:07:02+00:00",
            authors: ["an author"]
        )
        let book2 = uniqueBook(
            name: "another name",
            isbn: "another isbn",
            numberOfPages: 300,
            country: "another country",
            publisher: "another publisher",
            mediaType: "another media type",
            released: "2020-01-01T12:31:22+00:00",
            authors: ["another author"]
        )

        return [book1, book2]
    }
}
