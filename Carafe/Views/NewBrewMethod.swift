//
//  NewBrewMethod.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/17/22.
//

import SwiftUI

struct NewBrewMethod: View {
    
    @State var title: String
    @State var brewRatio: Int
    @State var minuteAmount: Int = 3
    @State var secondAmount: Int = 0
//    @ObservedObject var brewMethodStore: BrewMethodStore
    
    @ObservedObject var mainStore: Store
    @Binding var selectedBrewMethod: BrewMethod?
    
    @State var isActive = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section(header: Text("Name"), footer: Text("Add something like \"Chemex\" or \"Hario V60\"")) {
                TextField("Brewing Method", text: $title)
                    .disableAutocorrection(true)
            }
            
            Section(header: Text("Ratio"), footer: Text("Enter your preferred ratio for this brewing method")) {
                Stepper("1:\(brewRatio)", value: $brewRatio, in: 1...50, step: 1)
            }
            
            Section(header: Text("Timer Amount")) {
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        Picker("Timer Amount", selection: $minuteAmount) {
                            ForEach(0...59, id: \.self) { number in
//                                (number == minuteAmount) ? Text("\(number)") + Text(" minutes").fontWeight(.semibold): Text("\(number)")
                                Text("\(number)")
                            }
                        }
                        .overlay(Text("min").fontWeight(.semibold).padding(.leading, 65))
                        .pickerStyle(.wheel)
                        .frame(maxWidth: geometry.size.width / 2)
                        .clipped()
                        
                        Picker("Timer Amount", selection: $secondAmount) {
                            ForEach(0...59, id: \.self) { number in
//                                (number == secondAmount) ? Text("\(number)") + Text(" seconds").fontWeight(.semibold): Text("\(number)")
                                Text("\(number)")
                            }
                        }
                        .overlay(Text("sec").fontWeight(.semibold).padding(.leading, 65))
                        .pickerStyle(.wheel)
                        .frame(maxWidth: geometry.size.width / 2)
                        .clipped()
                    }
                }
                .frame(height: 200)
            }
        }
        .onChange(of: title) { newState in
            if (title != "" || title != " ") {
                isActive = true
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("New Method")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                    if (isActive) {
                        
                        let newBrewMethod = BrewMethod(id: UUID(), title: title, brewRatio: brewRatio, timerAmount: ((minuteAmount * 60) + secondAmount))
                        
                        mainStore.storage.brewMethods.append(newBrewMethod)
                        
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
