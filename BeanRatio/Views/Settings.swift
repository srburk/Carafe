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
//    @Binding var selectedBrewMethodIndex: Int
    
    @Binding var selectedBrewMethod: BrewMethod?
    
    func delete(at offsets: IndexSet) {
                
        offsets.forEach { index in
            if (brewMethodStore.brewMethods[index].id == selectedBrewMethod?.id) {
                
                brewMethodStore.brewMethods.remove(atOffsets: offsets)
                
                if (brewMethodStore.brewMethods.isEmpty) {
                    selectedBrewMethod = nil
                } else {
                    selectedBrewMethod = brewMethodStore.brewMethods.first
                }
            } else {
                brewMethodStore.brewMethods.remove(atOffsets: offsets)
            }
        }
        
        BrewMethodStore.save(brewMethods: brewMethodStore.brewMethods) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Brewing Method")) {
                    ForEach($brewMethodStore.brewMethods) { $brewMethod in
                        
                        let systemImage = (selectedBrewMethod?.id == brewMethod.id) ? "checkmark.circle.fill" : "circle"
                        
                        Label("\(brewMethod.title)", systemImage: systemImage).foregroundColor(.black)
                        
                            .onTapGesture {
                                selectedBrewMethod = brewMethod
                            }
                        
                    }
                    
                    .onDelete(perform: delete)

                    NavigationLink("New Method", destination: NewBrewMethod(title: "", brewRatio: 15, brewMethodStore: brewMethodStore, selectedBrewMethod: $selectedBrewMethod, presentationMode: self._presentationMode)).foregroundColor(.blue)
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
        Settings(brewMethodStore: BrewMethodStore(), selectedBrewMethod: .constant(BrewMethod(id: UUID(), title: "Chemex", brewRatio: 17)))
    }
}
