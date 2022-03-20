//
//  Store.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/19/22.
//

import Foundation

enum Theme : Codable, CaseIterable {
    case auto, dark, light
}

struct Defaults : Codable {
    var cupGramAmount: Double
    var defaultUnits: Units
    var defaultBrewMethod: BrewMethod?
    var themeMode: Theme
    
    init(cupGramAmount: Double, defaultUnits: Units, themeMode: Theme) {
        self.cupGramAmount = cupGramAmount
        self.defaultUnits = defaultUnits
        self.themeMode = themeMode
    }
}

struct Storage : Codable {
    var defaults: Defaults
    var brewMethods: [BrewMethod]
    var history: [History]
    
    init(defaults: Defaults, brewMethods: [BrewMethod], history: [History]) {
        self.defaults = defaults
        self.brewMethods = brewMethods
        self.history = history
    }
}

class Store: ObservableObject {
    
    @Published var storage: Storage = Storage(defaults: Defaults(cupGramAmount: 118.0, defaultUnits: .grams, themeMode: .auto), brewMethods: [], history: [])
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("store.data")
    }
    
    static func load(completion: @escaping (Result<Storage, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Storage(defaults: Defaults(cupGramAmount: 118.0, defaultUnits: .grams, themeMode: .auto), brewMethods: [], history: [])))
                    }
                    return
                }
                let storage = try JSONDecoder().decode(Storage.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(storage))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(storage: Storage, completion: @escaping (Result<Int, Error>)->Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(storage)
                    let outfile = try fileURL()
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(1))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
}
