//
//  AccentColorPicker.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/27/22.
//

import SwiftUI

struct AccentColorPicker: View {
    
    @StateObject var mainStore: Store
    
    var isLightAccent: Bool
    
    func colorOptionsColor(item: ColorOptions) -> Color {
        switch (item) {
        case .orange:
            return Color.orange
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        }
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(ColorOptions.allCases, id: \.self) { item in
                    
                    ZStack {
                        
                        if ((item == mainStore.storage.defaults.lightAccent && isLightAccent) || (item == mainStore.storage.defaults.darkAccent && !isLightAccent)) {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.secondary)
                                .frame(width: 45, height: 45)
                        }
                            
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(colorOptionsColor(item: item))
                            .frame(width: 35, height: 35)
                            .padding(4)
                        
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            if (isLightAccent) {
                                mainStore.storage.defaults.lightAccent = item
                            } else {
                                mainStore.storage.defaults.darkAccent = item
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

struct AccentColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        AccentColorPicker(mainStore: Store(), isLightAccent: true)
    }
}
