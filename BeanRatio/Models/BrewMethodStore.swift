//
//  BrewMethodStore.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/17/22.
//

import Foundation
import SwiftUI

class BrewMethodStore: ObservableObject {
    
    @Published var brewMethods: [BrewMethod] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("brewMethods.data")
    }
    
    static func load(completion: @escaping (Result<[BrewMethod], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let brewMethods = try JSONDecoder().decode([BrewMethod].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(brewMethods))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(brewMethods: [BrewMethod], completion: @escaping (Result<Int, Error>)->Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(brewMethods)
                    let outfile = try fileURL()
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(brewMethods.count))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    
}
