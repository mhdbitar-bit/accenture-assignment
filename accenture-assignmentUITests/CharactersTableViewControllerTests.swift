@testable import accenture_assignment
import XCTest

final class CharactersTableViewControllerTests: XCTestCase {

    func test_loadCharactersActions_requestCharactersFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedResourceReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadCharactersActions_isVisibleWhileLoadingCharacters() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeCharactersLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfuly")
        
        sut.simulateUserInitiatedResourceReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeCharactersWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadCharactersCompletion_rendersSuccessfullyloadedCharacters() {
        let character1 = makeCharacter()
        let character2 = makeCharacter(
            id: "2",
            name: "another name",
            gender: "another gender",
            culture: "a culture",
            born: "a born",
            died: "a died",
            father: "a father",
            mother: "a mther",
            spouse: "a spouse",
            titles: ["title 2"],
            aliases: ["aliasss 2"],
            playedBy: ["actor 2"],
            allegiances: [URL(string: "http://another-url.com")!]
        )
            
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeCharactersLoading(with: [character1], at: 0)
        assertThat(sut, isRendering: [character1])
        
        sut.simulateUserInitiatedResourceReload()
        loader.completeCharactersLoading(with: [character1, character2], at: 1)
        assertThat(sut, isRendering: [character1, character2])
    }
    
    func test_loadCharactersCompletion_doesNotAlertCurrentRenderingStateOnError() {
        let character1 = makeCharacter()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeCharactersLoading(with: [character1], at: 0)
        assertThat(sut, isRendering: [character1])
        
        sut.simulateUserInitiatedResourceReload()
        loader.completeCharactersWithError(at: 1)
        assertThat(sut, isRendering: [character1])
    }
    
    func test_loadCharactersCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeCharactersLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CharactersTableViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let viewModel = CharacterViewModel(loader: loader)
        let sut = CharactersTableViewController(viewModel: viewModel)
        trackForMemoryLeacks(loader, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: CharactersTableViewController, isRendering characters: [CharacterItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedResourceViews() == characters.count else {
            return XCTFail("Expected \(characters.count) characters, got \(sut.numberOfRenderedResourceViews()) instead", file: file, line: line   )
        }
        
        characters.enumerated().forEach { index, character in
            assertThat(sut, hasViewConfiguredFor: character, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: CharactersTableViewController, hasViewConfiguredFor character: CharacterItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.view(at: index) as? CharacterTableViewCell
        
        guard let cell = view else {
            return XCTFail("Expected \(UITableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.characterNameLabel.text, character.name, "Expected name text to be \(String(describing: character.name)) for character view at index \(index)", file: file, line: line)
        
        let formatter = ListFormatter()
        if let authors = formatter.string(from: character.playedBy) {
            XCTAssertEqual(cell.actorLabel.text, authors, "Expected actor text to be \(String(describing: authors)) for character view at index \(index)", file: file, line: line)
        } else {
            let actorLabelText = cell.actorLabel.text ?? ""
            XCTAssertTrue(actorLabelText.isEmpty, "Expected actor text to be empty")
        }
    }
    
    class LoaderSpy: CharacterLoader {
        private var completions = [(LoadCharacterResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadCharacterResult) -> Void) {
            completions.append(completion)
        }
        
        func completeCharactersLoading(with characters: [CharacterItem] = [], at index: Int = 0) {
            completions[index](.success(characters))
        }
        
        func completeCharactersWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index](.failure(error))
        }
    }
}
