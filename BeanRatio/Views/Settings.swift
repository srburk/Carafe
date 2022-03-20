//
//  Settings.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mainStore: Store
    
    @Binding var selectedBrewMethod: BrewMethod?
    
    func delete(at offsets: IndexSet) {
                
        offsets.forEach { index in
            if (mainStore.storage.brewMethods[index].id == selectedBrewMethod?.id) {
                
                mainStore.storage.brewMethods.remove(atOffsets: offsets)
                
                if (mainStore.storage.brewMethods.isEmpty) {
                    selectedBrewMethod = nil
                    mainStore.storage.defaults.defaultBrewMethod = selectedBrewMethod
                } else {
                    selectedBrewMethod = mainStore.storage.brewMethods.first
                    mainStore.storage.defaults.defaultBrewMethod = selectedBrewMethod
                }
            } else {
                mainStore.storage.brewMethods.remove(atOffsets: offsets)
            }
        }
        
        Store.save(storage: mainStore.storage) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Brewing Method")) {
                    ForEach($mainStore.storage.brewMethods) { $brewMethod in
                        
                        let systemImage = (selectedBrewMethod?.id == brewMethod.id) ? "checkmark.circle.fill" : "circle"
                        
                        Label("\(brewMethod.title)", systemImage: systemImage).foregroundColor(.black)
                        
                            .onTapGesture {
                                selectedBrewMethod = brewMethod
                                mainStore.storage.defaults.defaultBrewMethod = selectedBrewMethod
                            }
                        
                    }
                    
                    .onDelete(perform: delete)

                    NavigationLink("New Method", destination: NewBrewMethod(title: "", brewRatio: 15, mainStore: mainStore, selectedBrewMethod: $selectedBrewMethod, presentationMode: self._presentationMode)).foregroundColor(.blue)
                }
                
                // MARK: General Settings
                Section(header: Text("General")) {
                    
                    Picker("Theme", selection: $mainStore.storage.defaults.themeMode) {
                        Text("Match System Theme").tag(Theme.auto)
                        Text("Light").tag(Theme.light)
                        Text("Dark").tag(Theme.dark)
                            .navigationTitle("Theme")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    
                    Picker("Default Units", selection: $mainStore.storage.defaults.defaultUnits) {
                        Text("Grams").tag(Units.grams)
                        Text("Ounces").tag(Units.ounces)
                            .navigationTitle("Units")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    
                    NavigationLink("About", destination: Text("About this app"))
                }
                
                // MARK: Feedback and About
                Section(header: Text("Feedback")) {
                    Link("Email Me", destination: URL(string: "https://www.apple.com")!).foregroundColor(.primary)
                    Link("Twitter", destination: URL(string: "https://www.twitter.com")!).foregroundColor(.primary)
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
        Settings(mainStore: Store(), selectedBrewMethod: .constant(BrewMethod(id: UUID(), title: "Chemex", brewRatio: 17)))
    }
}
