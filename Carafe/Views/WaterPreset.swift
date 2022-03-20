//
//  WaterPreset.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct WaterPreset: View {
    
    // Binding passed from parent
    @Binding var waterAmount: String
    
    // animation for tapping
    @State var tap = false
    
    @ObservedObject var mainStore: Store
    
    @Environment(\.colorScheme) var colorScheme
    
    // Cool violet => Color(red: 109/255, green: 109/255, blue: 113)

    var number: Int
    
    var body: some View {
        ZStack {
            
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor((colorScheme == .light ? .black : Color(red: 55/255, green: 55/255, blue: 58/255)))
            
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
            waterAmount = String(Double(number) * (Double(mainStore.storage.defaults.cupGramAmount) ?? 0.0))
            tap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tap = false
            }
        }
        
        .animation(nil, value: tap)
        .scaleEffect(tap ? 0.85 : 1)
        .animation(.spring(), value: tap)
    }
}

struct WaterPreset_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self, content:         WaterPreset(waterAmount: .constant("0"), mainStore: Store(), number: 1)
.preferredColorScheme)

    }
}
