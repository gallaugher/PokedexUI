//
//  ContentView.swift
//  PokedexUI
//
//  Created by John Gallaugher on 7/21/22.
//

import SwiftUI

struct CreaturesView: View {
    @EnvironmentObject var creatures: Creatures
    
    var body: some View {
        NavigationStack{
            List(creatures.creatureArray) { creature in
                LazyVStack {
                    NavigationLink {
                        CreatureDetailView(creature: creature)
                    } label: {
                        Text("\(creature.name)")
                    }
                }
                .onAppear() {
                    if let lastPoke = creatures.creatureArray.last {
                        if creature.id == lastPoke.id && creatures.urlString.hasPrefix("https") {
                            Task {
                                await creatures.getData()
                            }
                        }
                    }
                }
                //                if let lastPoke = creatures.creatureArray.last {
                //                    if creature.id == lastPoke.id && creatures.urlString.hasPrefix("https") {
                ////                        ProgressView()
                //                        Text("")
                //                            .task {
                //                                await creatures.getData()
                //                            }
                //                    }
                //                }
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
            .toolbar {
                // id: and showsByDefault were needed to refresh bottom bar after returning from another view.
                ToolbarItem (id: UUID().uuidString, placement: .bottomBar, showsByDefault: true) {
                    Button("Load All") {
                        Task {
                            await creatures.loadAll()
                        }
                    }
                    .buttonStyle(.bordered)
                }
                ToolbarItem (placement:.status) {
                    Text("\(creatures.creatureArray.count) of \(creatures.count)")
                }
            }
            .task {
                await creatures.getData()
            }
        }
    }
    
    func checkIfLast(creature: Creature) {
        print("*** I can call this ***")
    }
}

//struct ListView: View {
//    @EnvironmentObject var creatures: Creatures
//
//    var body: some View {
//        List(creatures.creatureArray) {creature in
//            NavigationLink {
//                CreatureDetailView(creature: creature)
//            } label: {
//                Text("\(creature.name)")
//            }
//            checkIfLast(creature: creature)
//        }
//    }
//
//    func checkIfLast(creature: Creature) {
//        guard let lastPokemon = creatures.creatureArray.last else {
//            return
//        }
//        if lastPokemon.id == creature.id {
//            print("*** The last creature is \(creature.name) ***")
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        CreaturesView()
            .environmentObject(Creatures())
    }
}
