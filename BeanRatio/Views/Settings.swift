//
//  Settings.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Brewing Methods")) {
                    Label("French Press", systemImage: "checkmark")
                    Label("Chemex", systemImage: "circle").foregroundColor(.black)
                    Button(action: {
                        
                    }) {
                        Text("New")
                    }
                }
                Section(header: Text("General")) {
                    Text("About")
                    Text("Default Units")
                    Text("Appearance")
                }
            }
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Done")
                }
            }
            .navigationTitle("BeanRatio")
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
