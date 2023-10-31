//
//  FavoriteAnimalsView.swift
//  PawPark
//
//  Created by Viktor on 2023-10-31.
//


import SwiftUI

struct FavoriteDogsView: View {
    @ObservedObject var favoriteDogsManager: FavoriteDogsManager
    @State private var searchText = ""
    
    
    var body: some View {
        List {
            ForEach(favoriteDogsManager.favoriteDogs.filter {
                searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText)
            }) { dog in
                HStack {
                    // Display dog image (you can use AsyncImage here if you prefer)
                    VStack {
                        if let imageUrl = URL(string: dog.image_link) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60) // Set the desired size
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60) // Set the desired size
                                }
                            }
                        } else {
                            Image(systemName: "questionmark.diamond")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30) // Set the desired size
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Breed: \(dog.name)")
                        Text("Loves children: \(dog.good_with_children)")
                        Text("Playing with dogs: \(dog.good_with_other_dogs)")
                    }
                    
                    Spacer()
                    
                    
                }
            }
            .onDelete(perform: deleteFavoriteDog)
            
        }
        .searchable(text: $searchText)
        .navigationTitle("Favorite Dogs")
        .navigationBarItems(trailing: EditButton())
        .onReceive(favoriteDogsManager.$favoriteDogs) { _ in
             
         }
        
    }
    
     func deleteFavoriteDog(at offsets: IndexSet) {
        favoriteDogsManager.favoriteDogs.remove(atOffsets: offsets)
        favoriteDogsManager.saveFavoriteDogs() // Save changes after deletion
    }
    
    
    
}




