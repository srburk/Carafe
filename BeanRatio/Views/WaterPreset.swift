//
//  WaterPreset.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct WaterPreset: View {
    
    // Binding passed from parent
    @Binding var waterAmount: String
    
    // animation for tapping
    @State var tap = false
    
    var number: Int
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            
            if (isSelected) {
                Circle()
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 5).frame(width: 95, height: 95))
            } else {
                Circle()
                    .frame(width: 100, height: 100)
            }
            
            VStack {
                Image(systemName: "cup.and.saucer.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
                if (number == 1) {
                    Text("1 cup")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(1)
                } else {
                    Text("\(number) cups")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(1)
                }
            }
        }
        .onTapGesture {
            waterAmount = String(format: "%.1f", Double(number) * 86.4)
            tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tap = false
            }
        }
        
        .animation(nil, value: tap)
        .scaleEffect(tap ? 0.90 : 1)
        .animation(.spring(), value: tap)
    }
}

struct WaterPreset_Previews: PreviewProvider {
    static var previews: some View {
        WaterPreset(waterAmount: .constant("0"), number: 1, isSelected: true)
    }
}
