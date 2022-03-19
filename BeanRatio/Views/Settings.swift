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
    
    func delete(at offsets: IndexSet) {
        brewMethodStore.brewMethods.remove(atOffsets: offsets)
        
        
        
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
                        
//                        if (index == selectedBrewMethodIndex) {
//                            Label("\(brewMethodStore.brewMethods[index].title)", systemImage: "checkmark.circle.fill").foregroundColor(.black)
//                        } else {
//                            Label("\(brewMethodStore.brewMethods[index].title)", systemImage: "circle").foregroundColor(.black)
//                                .onTapGesture {
//                                    selectedBrewMethodIndex = index
//                                }
//                        }
                        
                        let systemImage = (brewMethodStore.brewMethods[selectedBrewMethodIndex].id == brewMethod.id) ? "checkmark.circle.fill" : "circle";
                        
                        Label("\(brewMethod.title)", systemImage: systemImage).foregroundColor(.black)
                        
                            .onTapGesture {
                                var count = 0
                                for _ in brewMethodStore.brewMethods {
                                    if (brewMethodStore.brewMethods[count].id == brewMethod.id) {
                                        selectedBrewMethodIndex = count
                                        return
                                    }
                                    count += 1
                                }
//                                selectedBrewMethodIndex = brewMethodStore.brewMethods.firstIndex(where: $0 == brewMethod)
                            }
                        
                    }
                    
                    .onDelete(perform: delete)

                    NavigationLink("New Method", destination: NewBrewMethod(title: "", brewRatio: 15, brewMethodStore: brewMethodStore, presentationMode: self._presentationMode)).foregroundColor(.blue)
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
