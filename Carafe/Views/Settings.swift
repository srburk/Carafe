//
//  Settings.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/16/22.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
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
                        
                        Label("\(brewMethod.title)", systemImage: systemImage).foregroundColor(.primary)
                        
                            .onTapGesture {
                                selectedBrewMethod = brewMethod
                                mainStore.storage.defaults.defaultBrewMethod = selectedBrewMethod
                            }
                        
                    }
                    
                    .onDelete(perform: delete)

                    NavigationLink("New Method", destination: NewBrewMethod(title: "", brewRatio: 15, mainStore: mainStore, selectedBrewMethod: $selectedBrewMethod, presentationMode: self._presentationMode)).foregroundColor(.blue)
                }
                
                // MARK: General Settings
                Section(header: Text("Units")) {
                                        
//                    Picker("Theme", selection: $mainStore.storage.defaults.themeMode) {
//                        Text("Match System Theme").tag(Theme.auto)
//                        Text("Light").tag(Theme.light)
//                        Text("Dark").tag(Theme.dark)
//                            .navigationTitle("Theme")
//                            .navigationBarTitleDisplayMode(.inline)
//                    }
                    
                    Picker(selection: $mainStore.storage.defaults.defaultUnits, label: Label("Default Units", systemImage: "scalemass").foregroundColor(.primary)) {
                        Text("Grams").tag(Units.grams)
                        Text("Ounces").tag(Units.ounces)
                    }
                    
                    HStack {
                        Label("Cup Size", systemImage: "cup.and.saucer").foregroundColor(.primary)
                        
                        TextField("Cup Size", text: $mainStore.storage.defaults.cupGramAmount)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.secondary)
                        
//                        TextField("Cup Size", text: $mainStore.storage.defaults.cupGramAmount)
//                            .multilineTextAlignment(.trailing)
//                            .keyboardType(.decimalPad)
//                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    
                }
                
                // MARK: Presets
                Section(header: Text("Presets")) {
                    Label("Water Presets", systemImage: "drop").foregroundColor(.primary)
                    Label("Preset 2", systemImage: "2.circle").foregroundColor(.primary)
                }
                
                // MARK: Feedback and About
                Section(header: Text("More")) {
                    
                    NavigationLink(destination: Text("Helo")) {
                        Label("Help", systemImage: "questionmark.circle")
                    }.foregroundColor(.primary)
                    
                    Link(destination: URL(string: "https://www.apple.com")!) {
                        Label("Send Feedback", systemImage: "envelope")
                    }.foregroundColor(.primary)
                    
                    NavigationLink(destination: Text("About this app")) {
                        Label("About", systemImage: "info.circle")
                    }.foregroundColor(.primary)
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        Store.save(storage: mainStore.storage) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }) {
                        Text("Done").foregroundColor(.primary)
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
