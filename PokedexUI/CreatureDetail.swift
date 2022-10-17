//
//  CreatureDetail.swift
//  PokedexUI
//
//  Created by John Gallaugher on 7/22/22.
//

import Foundation

@MainActor
//class CreatureDetail {
class CreatureDetail: ObservableObject {
    
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprites
    }
    
    private struct Sprites: Codable {
        var front_default: String?
    }
    
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
    @Published var urlString = ""
    
    func getData() async {
        print("🕸 We are accessing the url \(urlString)")
        
        // Create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let returned = try? JSONDecoder().decode(Returned.self, from: data) {
                self.height = returned.height
                self.weight = returned.weight
                self.imageURL = returned.sprites.front_default ?? ""
                print("Height: \(self.height), Weight: \(self.weight), URL: \(self.imageURL)")
            } else {
                print("😡 JSON ERROR: Could not decode returned data.")
            }
        } catch {
            print("😡 ERROR: Could not get URL from data at \(urlString). \(error.localizedDescription)")
        }
    }
}
