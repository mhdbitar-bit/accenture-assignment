@testable import accenture_assignment
import XCTest

final class CategoryEndpointTests: XCTestCase {
    
    func test_categories_endpointURL() {
        let baseURL = anyURL()
        let received = Endpoints.getCategories.url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "any-url.com", "host")
        XCTAssertEqual(received.query, "", "query")
    }
}
