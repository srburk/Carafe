//
//  BrewMethod.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/17/22.
//

import Foundation

struct BrewMethod: Identifiable, Codable {
    let id: UUID
    var title: String
    var brewRatio: Int
    var timerAmount: Int? // time in seconds
    
    init(id: UUID = UUID(), title: String, brewRatio: Int, timerAmount: Int = 180) {
        self.id = id
        self.title = title
        self.brewRatio = brewRatio
        self.timerAmount = timerAmount
    }
}
