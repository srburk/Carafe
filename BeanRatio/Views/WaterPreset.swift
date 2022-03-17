//
//  WaterPreset.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct WaterPreset: View {
    
    var number: Int
    var isSelected: Bool
    
    var body: some View {
        VStack {
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
        }
    }
}

struct WaterPreset_Previews: PreviewProvider {
    static var previews: some View {
        WaterPreset(number: 1, isSelected: true)
    }
}
