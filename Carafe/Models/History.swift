//
//  History.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/19/22.
//

import Foundation
import SwiftUI

struct History: Identifiable, Codable {
    let id: UUID
    var amount: Double
    
    init(id: UUID = UUID(), amount: Double) {
        self.id = id
        self.amount = amount
    }
}
