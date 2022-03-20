//
//  AmountObject.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/19/22.
//

import Foundation
import SwiftUI

class AmountObject: ObservableObject {
    
    func calculateCoffeeAmount() {
        switch (selectedUnit) {
        case .grams:
            coffeeAmount = String(format: "%.1f", (Double(waterAmount) ?? 0.0) / Double(brewRatio))
        case .ounces:
            coffeeAmount = String(format: "%.1f", ((Double(waterAmount) ?? 0.0) * 28.3495) / Double(brewRatio))
        }
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
            withAnimation {
                calculateCoffeeAmount()
            }
        }
    }
    
    @Published var selectedUnit: Units = .grams {
        didSet {
            calculateCoffeeAmount()
        }
    }
    
    @Published var coffeeAmount: String = "0"
}
