@testable import accenture_assignment
import XCTest

final class CharacterMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(try CharacterItemMapper.map(json, from: HTTPURLResponse(statusCode: code)))
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(try CharacterItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200)))
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONlist() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try CharacterItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: "1",
            name: "a name",
            gender: "a gender",
            culture: "a culture",
            born: "a born",
            died: "a died",
            father: "a father",
            mother: "a mother",
            spouse: "a spouse",
            titles: ["a title"],
            aliases: ["an aliases"],
            playedBy: ["a player"],
            allegiances: []
        )
        
        let item2 = makeItem(
            id: "2",
            name: "another name",
            gender: "another gender",
            culture: "another culture",
            born: "another born",
            died: "another died",
            father: "another father",
            mother: "another mother",
            spouse: "another spouse",
            titles: ["another title"],
            aliases: ["another aliases"],
            playedBy: ["another player"],
            allegiances: []
        )
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try CharacterItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
        
    private func makeItem(id: String, name: String, gender: String, culture: String, born: String, died: String, father: String, mother: String, spouse: String, titles: [String], aliases: [String], playedBy: [String], allegiances: [URL]) -> (model: CharacterItem, json: [String: Any]) {
        
        let item = CharacterItem(
            id: id,
            name: name,
            gender: gender,
            culture: culture,
            born: born,
            died: died,
            father: father,
            mother: mother,
            spouse: spouse,
            titles: titles,
            aliases: aliases,
            playedBy: playedBy,
            allegiances: allegiances
        )
        
        let json: [String: Any] = [
            "id": id,
            "name": name,
            "gender": gender,
            "culture": culture,
            "born": born,
            "died": died,
            "father": father,
            "mother": mother,
            "spouse": spouse,
            "titles": titles,
            "aliases": aliases,
            "playedBy": playedBy,
            "allegiances": []
        ]
        
        return (item, json)
    }
}
