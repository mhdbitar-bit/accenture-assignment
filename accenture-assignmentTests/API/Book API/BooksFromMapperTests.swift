@testable import accenture_assignment
import XCTest

final class BooksFromMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(try BooksItemMapper.map(json, from: HTTPURLResponse(statusCode: code)))
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(try BooksItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200)))
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONlist() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try BooksItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            name: "a name",
            isbn: "a isbn",
            numberOfPages: 100,
            country: "a country",
            publisher: "a publisher",
            mediaType: "a media type",
            released: "2020-08-28T15:07:02+00:00",
            authors: ["an author"]
        )
        let item2 = makeItem(
            name: "another name",
            isbn: "another isbn",
            numberOfPages: 300,
            country: "another country",
            publisher: "another publisher",
            mediaType: "another media type",
            released: "2020-01-01T12:31:22+00:00",
            authors: ["another author"]
        )
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try BooksItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
        
    private func makeItem(name: String, isbn: String, numberOfPages: Int, country: String, publisher: String, mediaType: String, released: String, authors: [String]) -> (model: BookItem, json: [String: Any]) {
        
        let item = BookItem(
            name: name,
            isbn: isbn,
            numberOfPages: numberOfPages,
            country: country,
            publisher: publisher,
            mediaType: mediaType,
            released: released,
            authors: authors
        )
        
        let json: [String: Any] = [
            "name": name,
            "isbn": isbn,
            "numberOfPages": numberOfPages,
            "country": country,
            "publisher": publisher,
            "mediaType": mediaType,
            "released": released,
            "authors": authors
        ]
        
        return (item, json)
    }
}
