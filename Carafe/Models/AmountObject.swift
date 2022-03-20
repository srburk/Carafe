//
//  AmountObject.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/19/22.
//

import Foundation
import SwiftUI

class AmountObject: ObservableObject {
    
    func calculateCoffeeAmount() {
        var tempCoffee = 0.0
        switch (selectedUnit) {
        case .grams:
            tempCoffee = (Double(waterAmount) ?? 0.0) / Double(brewRatio)
        case .ounces:
            tempCoffee = ((Double(waterAmount) ?? 0.0) * 28.3495) / Double(brewRatio)
        }
        coffeeAmount = (floor(tempCoffee) == tempCoffee) ? String(Int(tempCoffee)) : String(format: "%.1f", tempCoffee)
    }
    
    @Published var waterAmount: String = "0" {
        didSet {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                calculateCoffeeAmount()
            }
        }
    }
    
    @Published var brewRatio = 17 {
        didSet {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                calculateCoffeeAmount()
            }
        }
    }
    
    @Published var selectedUnit: Units = .grams {
        didSet {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                calculateCoffeeAmount()
            }
        }
    }
    
    @Published var coffeeAmount: String = "0"
}
