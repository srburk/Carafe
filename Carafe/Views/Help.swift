//
//  Help.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/21/22.
//

import SwiftUI

struct Help: View {
    var body: some View {
        VStack {
            
            Text("Creating Brewing Methods")
                .font(.title3)
                .padding()
                .padding(.top, 25)
            Text("Add new brewing methods by tapping the \"New Method\" Button in the settings menu")
                .padding([.bottom, .leading, .trailing])
            
            Divider()
            
            Text("Changing Water Presets")
                .font(.title3)
                .padding()
            Text("Edit the water presets in the settings menu under the \"Water Presets\" option")
                .padding([.bottom, .leading, .trailing])
            
            Divider()
            
            Text("Working With Units")
                .font(.title3)
                .padding()
            Text("Change the default units in the settings menu under the \"Default Units\" option")
                .padding([.bottom, .leading, .trailing])
            
            Spacer()

        }.navigationTitle("Help")
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        Help()
    }
}
