//
//  SearchView.swift
//  PawPark
//
//  Created by Viktor on 2023-10-31.
//

import SwiftUI

struct SearchView: View {
    @State private var dogs = [Dog]()
    @State private var name: String = ""
    @ObservedObject var favoriteDogsManager = FavoriteDogsManager()
    @State private var shouldRefreshData = false
    
    func getDogsInfo() {
        API().loadData(name: self.name) { (dogs) in
            DispatchQueue.main.async {
                self.dogs = dogs ?? []
            }
        }
    }
    
    var body: some View {
    
        
         NavigationStack {
                HStack {
                TextField("Enter dog's Breed", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                    .padding()
                Button("Fetch"){
                    getDogsInfo()
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding()
             
            Spacer()
             ScrollView{
                 VStack(alignment: .leading){
                     ForEach(dogs) { dog in
                         Text("Your Breed: \(dog.name)")
                         Text("Loves children:\(dog.good_with_children)")
                         Text("Playing with dogs:\(dog.good_with_other_dogs)")
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
                                             .frame(width: 200, height: 200) // Set the desired size
                                     case .failure:
                                         Image(systemName: "exclamationmark.triangle")
                                             .resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: 200, height: 200) // Set the desired size
                                     }
                                 }
                             } else {
                                 Image(systemName: "questionmark.diamond")
                                     .resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(width: 100, height: 100) // Set the desired size
                             }
                             
                             Button(action: {
                                 if favoriteDogsManager.favoriteDogs.contains(where: { $0.id == dog.id }) {
                                     favoriteDogsManager.removeFavoriteDog(dog)
                                 } else {
                                     favoriteDogsManager.addFavoriteDog(dog)
                                     shouldRefreshData = true
                                     
                                 }
                             }) {
                                 Text(favoriteDogsManager.favoriteDogs.contains(where: { $0.id == dog.id }) ? "Remove from Favorites" : "Add to Favorites")
                                     .padding()
                                     .background(Color.blue)
                                     .foregroundColor(.white)
                                     .cornerRadius(8)
                             }
                         }
                         .onAppear {
                                    // Check if the flag is set, and if so, refresh the data
                                    if shouldRefreshData {
                                        favoriteDogsManager.loadFavoriteDogs()
                                        shouldRefreshData = false // Reset the flag after refreshing data
                                    }
                                }
                     }
                 }
                     
             }
            .scrollIndicators(.hidden)
            .navigationTitle("Dog Park")
        }
         
        }
    }


#Preview {
    SearchView()
}
