//
//  ContentView.swift
//  PawPark
//
//  Created by Viktor on 2023-10-31.
//

import SwiftUI

struct ContentView: View {
    @State private var dogs = [Dog]()
    @State private var name: String = ""
    @ObservedObject var favoriteDogsManager = FavoriteDogsManager()
    
    var body: some View {
        NavigationView {
            TabView {
                // Search Tab
                NavigationView {
                    SearchView()
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag("Search")
                
                // Favorites Tab
                NavigationView {
                    FavoriteDogsView(favoriteDogsManager: favoriteDogsManager)
                }
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag("Favorites")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
