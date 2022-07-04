//
//  CharacterItem.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/4/22.
//

import Foundation

struct CharacterItem: Equatable {
    let id: String
    let name: String
    let gender: String
    let culture: String
    let born: String
    let died: String
    let father: String
    let mother: String
    let spouse: String
    let titles: [String]
    let aliases: [String]
    let playedBy: [String]
    let allegiances: [URL]
    
    init(id: String, name: String, gender: String, culture: String, born: String, died: String, father: String, mother: String, spouse: String, titles: [String], aliases: [String], playedBy: [String], allegiances: [URL]) {
        self.id = id
        self.name = name
        self.gender = gender
        self.culture = culture
        self.born = born
        self.died = died
        self.father = father
        self.mother = mother
        self.spouse = spouse
        self.titles = titles
        self.aliases = aliases
        self.playedBy = playedBy
        self.allegiances = allegiances
    }
}
