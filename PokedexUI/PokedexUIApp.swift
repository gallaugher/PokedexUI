//
//  PokedexUIApp.swift
//  PokedexUI
//
//  Created by John Gallaugher on 7/21/22.
//

import SwiftUI

@main
struct PokedexUIApp: App {
    @StateObject var creatures = Creatures()
    
    var body: some Scene {
        WindowGroup {
            CreaturesView()
                .environmentObject(Creatures())
        }
    }
}
