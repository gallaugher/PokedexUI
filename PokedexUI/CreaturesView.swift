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
            List {
                ForEach(0..<creatures.creatureArray.count, id: \.self) { index in
                    NavigationLink {
                        CreatureDetailView(creature: creatures.creatureArray[index])
                    } label: {
                        Text("\(index+1). \(creatures.creatureArray[index].name)")
                            .onAppear() {
                                // Was hoping that I could tell when I'm looking at the last element of the creaturesArray, and if so, I'd call to reload
                                print("\(index+1). \(creatures.creatureArray[index].name)")
                                creatures.shouldLoad(index: index)
                            }
                    }
                }
                .font(.title2)
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
                // I see that this calls every time I return from DetailView. It's not terrible that it does this, but it's unintended. I had intended to only load one page at a time when I scroll to the last element of creaturesArray OR load them all if the Load All button is pressed. Can I limit this so that it executes only once when the CreaturesDetail first shows? I suppose I could call it in the init of Creatures, instead.
                await creatures.getData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        CreaturesView()
            .environmentObject(Creatures())
    }
}
