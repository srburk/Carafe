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

func calculateCoffee(amount: Int, ratio: Int) -> Int {
    return amount / ratio
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
//        didSet {
//            animateCoffeeAmount = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.animateCoffeeAmount = false
//            }
//        }
//    }
//    @Published var animateCoffeeAmount: Bool = false
}

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @ObservedObject var amountObject = AmountObject()
        
    // MARK: Unit State
    @State var selectedUnit: Units = .grams
    
    // MARK: Brewing Bindings
    @State var brewMethod = "Chemex"
    
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
//                        .transition(.opacity)
//                        .animation(nil, value: amountObject.animateCoffeeAmount)
//                        .animation(.spring(), value: amountObject.animateCoffeeAmount)
                    
                    switch(selectedUnit) {
                        case .grams:
                            Text("grams of coffee")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .regular))
                                .padding(.bottom, 25)
                        
                        case .ounces:
                            Text("ounces of coffee")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .regular))
                                .padding(.bottom, 25)
                        
                    }
                    
                    
                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .foregroundColor(.white)
                        
                        VStack() {
                            
                            HStack(spacing: 25) {
                                WaterPreset(waterAmount: $amountObject.waterAmount, number: 1)
                                WaterPreset(waterAmount: $amountObject.waterAmount, number: 2)
                                WaterPreset(waterAmount: $amountObject.waterAmount, number: 3)
                            }
                            .padding(.top, 25)

                            Text("Water Amount")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing, .top], 15)
                                .font(.headline)

                            HStack {
                                
                                TextField("Enter Amount", text: $amountObject.waterAmount)
                                    .padding()
                                    .frame(width: 100, height: 30)
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
                            brewMethod = "chemex"
                        }) {
                            HStack {
                                Image(systemName: "chevron.down")
                                Text("Chemex")
                                    .font(.title3)
                            }.foregroundColor(.white)
                        }
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isShowingSettings) {
            Settings()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
