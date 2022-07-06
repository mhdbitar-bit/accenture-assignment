@testable import accenture_assignment
import XCTest

final class CharacterPresenterTests: XCTestCase {

    func test_map_createsViewModels() {
        let characters = uniqueCharacters()
        
        let viewModel = CharacterPresenter.map(characters)
        
        XCTAssertEqual(viewModel.characters, characters)
    }
    
    // MARK: - Hepers
    
    private func uniqueCharacter(id: String, name: String, gender: String, culture: String, born: String, died: String, father: String, mother: String, spouse: String, titles: [String], aliases: [String], playedBy: [String], allegiances: [URL]) -> CharacterItem {
        return CharacterItem(
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
    }

    private func uniqueCharacters() -> [CharacterItem] {
        let character1 = uniqueCharacter(
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
        
        let character2 = uniqueCharacter(
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

        return [character1, character2]
    }
}

