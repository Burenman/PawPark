//
//  DogModel.swift
//  PawPark
//
//  Created by Viktor on 2023-10-31.
//

import Foundation

import UIKit


struct Dog: Identifiable, Codable {
    let id = UUID()
    var name: String
    var image_link: String
    var good_with_children: Int
    var good_with_other_dogs: Int
    var shedding: Int
    var grooming: Int
  
}

let apiKey = Secret.apiKey

class API: ObservableObject {
    @Published var dogs = [Dog]()
    
    func loadData(name: String, completion:@escaping ([Dog]?) -> ()) {
        let name = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/dogs?name="+name!)!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let dogs = try JSONDecoder().decode([Dog].self, from: data)
                    completion(dogs)
                } catch {
                    print("Error decoding weather data: \(error)")
                    completion(nil)
                }
            } else {
                print("No data received from the server")
                completion(nil)
            }
        }.resume()
    }
}

