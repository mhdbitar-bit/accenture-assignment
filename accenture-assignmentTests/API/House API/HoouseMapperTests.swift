@testable import accenture_assignment
import XCTest

final class HoouseMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(try HouseItemMapper.map(json, from: HTTPURLResponse(statusCode: code)))
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(try HouseItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200)))
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONlist() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try HouseItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: "1",
            name: "a name",
            region: "a region",
            title: "a title"
        )
        
        let item2 = makeItem(
            id: "2",
            name: "another name",
            region: "another region",
            title: "another title"
        )
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try HouseItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
        
    private func makeItem(id: String, name: String, region: String, title: String) -> (model: HouseItem, json: [String: Any]) {
        
        let item = HouseItem(
            id: id,
            name: name,
            region: region,
            title: title,
            imageURL: nil
        )
        
        let json: [String: Any] = [
            "id": id,
            "name": name,
            "region": region,
            "title": title
        ]
        
        return (item, json)
    }
}
