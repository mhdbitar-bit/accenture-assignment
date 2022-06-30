@testable import accenture_assignment
import XCTest

class RemoteCategoryLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteCategoryLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteCategoryLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
