//
//  CharacterPresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

final class CharacterPresenter {
    static func map(_ characters: [CharacterItem]) -> CharacterViewModel {
        return CharacterViewModel(characters: characters)
    }
}
