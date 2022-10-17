//
//  CreatureDetailView.swift
//  PokedexUI
//
//  Created by John Gallaugher on 7/22/22.
//

import SwiftUI

struct CreatureDetailView: View {
    @State var creature: Creature
    @StateObject var creatureDetail = CreatureDetail()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
            Text(creature.name.capitalized)
                .font(.largeTitle)
                .bold()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom)
            HStack {
                
                AsyncImage(url: URL(string: creatureDetail.imageURL)){ image in
                    image
                        .resizable()
                        .scaledToFit()
                        .background(.white)
                        .cornerRadius(16)
                        .shadow(radius: 8, x: 5, y: 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        }
                        .padding()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity, maxHeight: 96)
                }

                VStack(alignment: .leading) {
                    HStack (alignment: .top) {
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                            .fixedSize()
                        VStack (alignment: .trailing) {
                            Text(String(format: "%.1f", creatureDetail.height))
                                .font(.largeTitle)
                                .bold()
                                .fixedSize()
                        }
                    }
                    .padding(.bottom, 3)
                    HStack (alignment: .top) {
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                            .fixedSize()
                        Text(String(format: "%.1f", creatureDetail.weight))
                            .font(.largeTitle)
                            .bold()
                            .fixedSize()
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .task {
            creatureDetail.urlString = creature.url
            await creatureDetail.getData()
        }
        Spacer()
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreatureDetailView_Previews: PreviewProvider {
    static var creature = Creature(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/")
    static var creatureDetail = CreatureDetail()
    
    static var previews: some View {
        NavigationStack {
            CreatureDetailView(creature: creature, creatureDetail: creatureDetail)
        }
    }
}
