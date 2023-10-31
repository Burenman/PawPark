//
//  DataManager.swift
//  PawPark
//
//  Created by Viktor on 2023-10-31.
//

import Foundation



class FavoriteDogsManager: ObservableObject {
    @Published var favoriteDogs: [Dog] = {
        if let data = UserDefaults.standard.data(forKey: "favoriteDogs") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Dog].self, from: data) {
                return decoded
            }
        }
        return []
    }()

    func addFavoriteDog(_ dog: Dog) {
        favoriteDogs.append(dog)
        objectWillChange.send() // Inform SwiftUI that changes are happening
        saveFavoriteDogs() // Save the updated list after adding a dog
        objectWillChange.send() // Inform SwiftUI again after saving changes
    }
    func removeFavoriteDog(_ dog: Dog) {
        if let index = favoriteDogs.firstIndex(where: { $0.id == dog.id }) {
            favoriteDogs.remove(at: index)
            saveFavoriteDogs()
        }
    }

    func saveFavoriteDogs() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteDogs) {
            UserDefaults.standard.set(encoded, forKey: "favoriteDogs")
        }
    }
    
    func loadFavoriteDogs() -> [Dog] {
            if let data = UserDefaults.standard.data(forKey: "favoriteDogs") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([Dog].self, from: data) {
                    return decoded
                }
            }
            return []
        }
    
    }

