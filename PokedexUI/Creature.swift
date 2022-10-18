//
//  Creature.swift
//  PokedexUI
//
//  Created by John Gallaugher on 7/21/22.
//

import Foundation

struct Creature: Hashable, Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
}
