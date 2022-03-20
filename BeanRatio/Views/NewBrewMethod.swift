//
//  NewBrewMethod.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 3/17/22.
//

import SwiftUI

struct NewBrewMethod: View {
    
    @State var title: String
    @State var brewRatio: Int
//    @ObservedObject var brewMethodStore: BrewMethodStore
    
    @ObservedObject var mainStore: Store
    @Binding var selectedBrewMethod: BrewMethod?
    
    @State var isActive = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                TextField("Brewing Method", text: $title)
            }
            
            Section(header: Text("Ratio")) {
                Stepper("1:\(brewRatio)", value: $brewRatio, in: 1...50, step: 1)
            }
        }
        .onChange(of: title) { newState in
            if (title != "" || title != " ") {
                isActive = true
            }
        }
        .listStyle(.grouped)
        .navigationTitle("New Method")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                    if (isActive) {
                        
                        let newBrewMethod = BrewMethod(id: UUID(), title: title, brewRatio: brewRatio)
                        
                        mainStore.storage.brewMethods.append(newBrewMethod)
//                        BrewMethodStore.save(brewMethods: mainStore.storage.brewMethods) { result in
//                            if case .failure(let error) = result {
//                                fatalError(error.localizedDescription)
//                            }
//                        }
                        Store.save(storage: mainStore.storage) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        
                        selectedBrewMethod = newBrewMethod
                    }
                    
                }) {
                    if (isActive) {
                        Text("Add").foregroundColor(.accentColor)
                    } else {
                        Text("Add").foregroundColor(.gray)
                    }
                }
            }
        }
}
}

struct NewBrewMethod_Previews: PreviewProvider {
    // [BrewMethod(id: UUID(), title: "Chemex", brewRatio: 15), BrewMethod(id: UUID(), title: "Pourover", brewRatio: 15)]
    
    static var previews: some View {
        NewBrewMethod(title: "Hello", brewRatio: 17, mainStore: Store(), selectedBrewMethod: .constant(BrewMethod(id: UUID(), title: "Chemex", brewRatio: 17)))
    }
}
