//
//  Creatures.swift
//  PokedexUI
//
//  Created by John Gallaugher on 7/21/22.
//

import Foundation

@MainActor
class Creatures: ObservableObject {
    
    //    init() {
    //        self.creatureArray.append(Creature(name: "Pikachu", url: ""))
    //        self.creatureArray.append(Creature(name: "Squirtle", url: ""))
    //        self.creatureArray.append(Creature(name: "Jigglypuff", url: ""))
    //    }
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
    
    var count = 0
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    @Published var creatureArray: [Creature] = []
    var isFetching = false
    
    func getData() async {
        guard urlString.hasPrefix("http") else {return}
        guard !isFetching else { return }
        isFetching = true
        
        print("🕸 We are accessing the url \(urlString)")
        
        // Create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isFetching = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let returned = try? JSONDecoder().decode(Returned.self, from: data) {
                self.count = returned.count
                self.urlString = returned.next ?? ""
                DispatchQueue.main.async {
                    self.creatureArray = self.creatureArray + returned.results
                }
                isFetching = false
            } else {
                isFetching = false
                print("😡 JSON ERROR: Could not decode returned data.")
            }
        } catch {
            isFetching = false
            print("😡 ERROR: Could not get URL from data at \(urlString). \(error.localizedDescription)")
        }
    }
    
    func checkIfLast(creature: Creature) {
        print("**** COULD CALL checkIfLast! ***")
    }
    
    func shouldLoad(index: Int) {
        
        if index == self.creatureArray.count-1 && self.urlString.hasPrefix("http") {
            print("calling getData from inside shouldLoad was called!")
            Task {
                await self.getData()
            }
        }
    }
    
    func loadAll() async {
        // Am trying to recursively call getData until I get a page to the last page, where urlStsring should be an emptyString
        print("LLL loadAll was called! LLL")
        while self.urlString.hasPrefix("http") && !self.isFetching {
                print("Called getData in loadAll")
                await self.getData()
                await loadAll()
        }
    }
}
