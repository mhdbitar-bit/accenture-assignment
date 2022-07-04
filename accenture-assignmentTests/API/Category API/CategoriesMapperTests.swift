@testable import accenture_assignment
import XCTest

final class CategoriesMapperTests: XCTestCase {

    func test_map_deliversErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try CategoryItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_deliversErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try CategoryItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONlist() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try CategoryItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: 1, name: "a name")
        let item2 = makeItem(id: 2, name: "another name")
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try CategoryItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
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
}
