//
//  ContentView.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 10/21/21.
//

import SwiftUI
import UIKit
import Combine

enum Units: String, CaseIterable {
    case grams, ounces
}

class AmountObject: ObservableObject {
    
    @Published var waterAmount: String = "0" {
        didSet {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                coffeeAmount = String(format: "%.1f", (Double(waterAmount) ?? 0.0) / Double(brewRatio))
            }
        }
    }
    @Published var brewRatio = 17 {
        didSet {
            withAnimation {
                coffeeAmount = String(format: "%.1f", (Double(waterAmount) ?? 0.0) / Double(brewRatio))
            }
        }
    }
    
    @Published var coffeeAmount: String = "0"
}

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
//    var defaultBrewMethod = BrewMethod(id: UUID(), title: "Pourover", brewRatio: 15)
    @State var brewMethodName = ""
    
    @StateObject var brewMethodStore = BrewMethodStore()
    @State var selectedBrewMethodIndex = 0
    
    // keep track of selected BrewMethod
    @State var selectedBrewMethod: BrewMethod? = nil

    @ObservedObject var amountObject = AmountObject()
        
    // MARK: Unit State
    @State var selectedUnit: Units = .grams
    
    // MARK: View Layout bindings
    @State private var isShowingSettings = false
            
    var body: some View {
        NavigationView {
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
                            .foregroundColor(.white)
                        
                        VStack() {
                            
                            HStack(spacing: 25) {
                                ForEach(1..<4) { index in
                                    WaterPreset(waterAmount: $amountObject.waterAmount, number: index)
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
                                    .background(Color(red: 238/255, green: 238/255, blue: 238/255))
                                    .cornerRadius(5)
                                    .keyboardType(.decimalPad)

                                Picker("Units", selection: $selectedUnit) {
                                    Text("grams").tag(Units.grams)
                                    Text("ounces").tag(Units.ounces)
                                }
                                    .pickerStyle(.segmented)
                            }
                            .padding([.leading, .trailing], 15)
                            
                            Text("Brew Ratio")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing, .top], 15)
                                .font(.headline)
                            
                            Stepper("1:\(amountObject.brewRatio)", value: $amountObject.brewRatio, in: 1...50, step: 1)
                                .padding([.leading, .trailing], 15)
                            
                            List {
                                Section(header: Text("Previous Brews").font(.headline).foregroundColor(.black)) {
                                    Text("346 grams")
                                    Text("500 grams")
                                }
                            }
                                .background(Color.white)
                                .listStyle(.plain)
                                                                                    
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
//                                Text("\(brewMethodStore.brewMethods.count == 0 ? " " : brewMethodStore.brewMethods[selectedBrewMethodIndex].title)")
//                                    .font(.title3)
                                
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
            BrewMethodStore.load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .success(let brewMethods):
                    brewMethodStore.brewMethods = brewMethods
                    selectedBrewMethod = (brewMethodStore.brewMethods.count == 0) ? nil : brewMethodStore.brewMethods.first
                }
            }
            
            amountObject.brewRatio = brewMethodStore.brewMethods.count == 0 ? 15 : brewMethodStore.brewMethods[selectedBrewMethodIndex].brewRatio
        }
        
        .onChange(of: selectedBrewMethodIndex) { newState in
            amountObject.brewRatio = brewMethodStore.brewMethods.count == 0 ? 15 : brewMethodStore.brewMethods[selectedBrewMethodIndex].brewRatio
        }
        
        .sheet(isPresented: $isShowingSettings) {
            Settings(brewMethodStore: brewMethodStore, selectedBrewMethodIndex: $selectedBrewMethodIndex, selectedBrewMethod: $selectedBrewMethod)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
