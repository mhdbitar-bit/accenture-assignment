//
//  CharacterLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation

typealias LoadCharacterResult = Result<[CharacterItem], Error>

protocol CharacterLoader {
    func load(completion: @escaping (LoadCharacterResult) -> Void)
}
