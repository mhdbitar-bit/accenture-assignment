@testable import accenture_assignment
import XCTest

final class RemoteLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load  { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expcat(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnMapperError() {
        let (sut, client) = makeSUT(mapper: { _, _ in
            throw anyNSError()
        })
        
        expcat(sut, toCompleteWith: failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: anyData())
        }
    }
    
    func test_load_deliversMappedResource() {
        let resource = "a resource"
        
        let (sut, client) = makeSUT(mapper: { data, _ in
            String(data: data, encoding: .utf8)!
        })
        
        expcat(sut, toCompleteWith: .success(resource)) {
            client.complete(withStatusCode: 200, data: Data(resource.utf8))
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteLoader? = RemoteLoader<String>(url: url, client: client) { _, _ in "any" }
        
        var capturedResults = [RemoteLoader<String>.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         mapper: @escaping RemoteLoader<String>.Mapper = { _, _ in "any" },
                         file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(url: url, client: client, mapper: mapper)
        trackForMemoryLeacks(sut, file: file, line: line)
        trackForMemoryLeacks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteLoader<String>.Error) -> RemoteLoader<String>.Result {
        return .failure(error)
    }
    
    private func makeItem(id: Int, name: String) -> (model: CategoryItem, json: [String: Any]) {
        
        let item = CategoryItem(id: id, name: name)
        
        let json: [String: Any] = [
            "type": item.id,
            "category_name": item.name
        ]
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private func expcat(_ sut: RemoteLoader<String>, toCompleteWith expectedResult: RemoteLoader<String>.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteLoader<String>.Error), .failure(expectedError as RemoteLoader<String>.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
       
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
