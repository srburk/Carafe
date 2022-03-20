//
//  ContentView.swift
//  Carafe
//
//  Created by Sam : on 10/21/21.
//

// TODO: 1. Project Name
//       2. Launch Screen

import SwiftUI
import UIKit
import Combine

struct ContentView: View {
    
//    init(mainStore: Store) {
//        UITableView.appearance().backgroundColor = .clear
//    }
    
    // MARK: Environment Variables
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) private var scenePhase

    // Persistent Store
    @ObservedObject var mainStore: Store
    
    // MARK: States
    @State var brewMethodName = ""
    @State public var selectedBrewMethod: BrewMethod? = nil
    @State private var isShowingSettings = false

    @ObservedObject var amountObject = AmountObject()
        
    func delete(at offsets: IndexSet) {
                        
        mainStore.storage.history.remove(atOffsets: offsets)
        
        Store.save(storage: mainStore.storage) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
            
    var body: some View {
        return NavigationView {
            ZStack {
                
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                VStack {
                                        
                    Text(amountObject.coffeeAmount)
                        .foregroundColor(.white)
                        .font(.system(size: 100, weight: .semibold))
                    
                    Text("grams of coffee")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .regular))
                        .padding(.bottom, 25)
                    
                    
                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .foregroundColor((colorScheme == .light ? Color.white : Color(red: 35/255, green: 35/255, blue: 35/255)))
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .shadow(color: (colorScheme == .light ? Color.gray : Color(red: 55/255, green: 55/255, blue: 55/255)), radius: 7)
                        
                        VStack() {
                            
                            HStack(spacing: 25) {
                                ForEach(1..<4) { index in
                                    WaterPreset(waterAmount: $amountObject.waterAmount, mainStore: mainStore, number: index)
                                }
                            }
                            .padding(.top, 25)

                            Text("Water Amount")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing, .top], 15)
                                .font(.headline)

                            HStack {
                                
                                TextField("Enter Amount", text: $amountObject.waterAmount)
                                    .padding()
                                    .frame(height: 30)
                                    .background((colorScheme == .light ? Color(red: 238/255, green: 238/255, blue: 238/255) : Color(red: 55/255, green: 55/255, blue: 58/255)))
                                    .cornerRadius(5)
                                    .keyboardType(.decimalPad)

                                Picker("Units", selection: $amountObject.selectedUnit) {
                                    Text("grams").tag(Units.grams)
                                    Text("ounces").tag(Units.ounces)
                                }
                                    .pickerStyle(.segmented)
                            }
                            .padding([.leading, .trailing], 15)
                            
                            Text("Brewing Ratio")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing, .top], 15)
                                .font(.headline)
                            
                            Stepper("1:\(amountObject.brewRatio)", value: $amountObject.brewRatio, in: 1...50, step: 1)
                                .padding([.leading, .trailing], 15)
                            
                            if (!mainStore.storage.history.isEmpty) {
                                List {
                                    Section(header: Text("History").font(.headline).foregroundColor(.primary)) {
                                        ForEach(mainStore.storage.history) { history in
                                            Text(String("\(history.amount)g of water"))
                                                .onTapGesture {
                                                    amountObject.waterAmount = String(history.amount)
                                                }
                                        }
                                        .onDelete(perform: delete)
                                        .listRowBackground(colorScheme == .light ? .white : Color(red: 35/255, green: 35/255, blue: 35/255))
                                    }
                                }
                                .background(colorScheme == .light ? .white : Color(red: 35/255, green: 35/255, blue: 35/255))
                                .listStyle(.plain)
                            } else {
                                Spacer()
                            }
                            
                        }

                    }
                    .ignoresSafeArea(.all)
                    
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
  
                        Button(action: {
                            isShowingSettings.toggle()
                        }) {
                            HStack {
                                Image(systemName: "chevron.down")
                                
                                Text("\(selectedBrewMethod?.title ?? " ")")
                                    .font(.title3)
                            }.foregroundColor(.white)
                        }
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {

            Store.load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .success(let storage):
                    mainStore.storage.defaults = storage.defaults
                    mainStore.storage.history = storage.history
                    mainStore.storage.brewMethods = storage.brewMethods
                    
                    if (storage.defaults.defaultBrewMethod != nil) {
                        selectedBrewMethod = storage.defaults.defaultBrewMethod
                    } else {
                        selectedBrewMethod = (mainStore.storage.brewMethods.count == 0) ? nil : mainStore.storage.brewMethods.first
                    }
                }
            }
                        
        }
        
        .onChange(of: scenePhase) { phase in
            
            if phase == .inactive {
                
                if (Double(amountObject.waterAmount) != 0.0 && Double(amountObject.waterAmount) != mainStore.storage.history.first?.amount) {
                    
                    
                    
                    mainStore.storage.history.insert(History(id: UUID(), amount: Double(amountObject.waterAmount) ?? 500.0), at: 0)
                    
                    Store.save(storage: mainStore.storage) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                    
                    if (mainStore.storage.history.count > 4) {
                        mainStore.storage.history.remove(at: mainStore.storage.history.endIndex - 1)
                    }
                }
                
            }
                
        }
        
        .onChange(of: selectedBrewMethod?.brewRatio) { _ in
            amountObject.brewRatio = selectedBrewMethod?.brewRatio ?? 15
        }
        
        .sheet(isPresented: $isShowingSettings) {
            Settings(mainStore: mainStore, selectedBrewMethod: $selectedBrewMethod)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        ForEach(ColorScheme.allCases, id: \.self, content: ContentView( mainStore: Store()).preferredColorScheme)
    }
}
