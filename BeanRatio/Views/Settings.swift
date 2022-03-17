//
//  Settings.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var brewMethodStore: BrewMethodStore
    @Binding var selectedBrewMethodIndex: Int
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Brewing Method")) {
                    ForEach(brewMethodStore.brewMethods.indices) { index in
                        
                        if (index == selectedBrewMethodIndex) {
                            Label("\(brewMethodStore.brewMethods[index].title)", systemImage: "checkmark.circle.fill").foregroundColor(.black)
                        } else {
                            Label("\(brewMethodStore.brewMethods[index].title)", systemImage: "circle").foregroundColor(.black)
                                .onTapGesture {
                                    selectedBrewMethodIndex = index
                                }
                        }
                        
                    }

                    NavigationLink("New Method", destination: NewBrewMethod(title: "Hello", brewRatio: 4, brewMethodStore: brewMethodStore, presentationMode: self._presentationMode)).foregroundColor(.blue)
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
        Settings(brewMethodStore: BrewMethodStore(), selectedBrewMethodIndex: .constant(1))
    }
}
