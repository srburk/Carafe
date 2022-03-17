//
//  Settings.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var brewMethods: [BrewMethod]
    @Binding var selectedBrewMethodIndex: Int
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Brewing Method")) {
                    ForEach(brewMethods.indices) { index in
                        
                        if (index == selectedBrewMethodIndex) {
                            Label("\(brewMethods[index].title)", systemImage: "checkmark.circle.fill").foregroundColor(.black)
                        } else {
                            Label("\(brewMethods[index].title)", systemImage: "circle").foregroundColor(.black)
                                .onTapGesture {
                                    selectedBrewMethodIndex = index
                                }
                        }
                        
                    }
//                    Label("French Press", systemImage: "checkmark.circle.fill").foregroundColor(.black)
//                    Label("Chemex", systemImage: "circle").foregroundColor(.black)
                    NavigationLink("New Method", destination: NewBrewMethod(title: "Hello", brewRatio: 4)).foregroundColor(.blue)
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
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done").foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(brewMethods: .constant([BrewMethod(id: UUID(), title: "Chemex", brewRatio: 15), BrewMethod(id: UUID(), title: "Pourover", brewRatio: 15)]), selectedBrewMethodIndex: .constant(1))
    }
}
