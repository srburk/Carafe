//
//  ContentView.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 10/21/21.
//

import SwiftUI
import UIKit

enum Units: String, CaseIterable {
    case grams, ounces
}

func calculateCoffee(amount: Int, ratio: Int) -> Int {
    return amount / ratio
}

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
        
    // MARK: Unit States
    @State var waterAmount = "0"
    @State var coffeeAmount = "0"
    @State var selectedUnit: Units = .grams
    
    // MARK: Brewing Bindings
    @State var brewMethod = "Chemex"
    @State var brewRatio = 17
    
    // MARK: View Layout bindings
    @State private var isShowingSettings = false
            
    var body: some View {
        NavigationView {
            ZStack {
                
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(Color.black)
                
                VStack {
                                        
                    Text(coffeeAmount)
                        .foregroundColor(.white)
                        .font(.system(size: 100, weight: .semibold))
                    
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
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 25) {
                                    WaterPreset(number: 1, isSelected: true)
                                    ForEach(1..<9) { preset in
                                        WaterPreset(number: preset, isSelected: false)
                                    }
                                }
                            }
                            .padding(.top, 25)
                            .padding(.leading, 15)

                            Text("Water Amount")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing, .top], 15)
                                .font(.headline)

                            HStack {
                                
                                TextField("Enter Amount", text: $waterAmount)
                                    .padding()
                                    .frame(height: 30)
                                    .background(Color(red: 238/255, green: 238/255, blue: 238/255))
                                    .cornerRadius(5)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: waterAmount) { newAmount in
                                        coffeeAmount = String(calculateCoffee(amount: Int(waterAmount) ?? 0, ratio: brewRatio))
                                    }

                                Picker("Units", selection: $selectedUnit) {
                                    Text("g / mL").tag(Units.grams)
                                    Text("fl. oz.").tag(Units.ounces)
                                }
                                    .pickerStyle(.segmented)
                            }
                            .padding([.leading, .trailing], 15)
                            
                            List {
                                Section(header: Text("Previous Brews").font(.headline).foregroundColor(.black)) {
                                    Text("346 grams")
                                    Text("500 grams")
                                }
                            }
                                .background(Color.white)
                                .listStyle(.plain)
                            
//                            Spacer()
                                                        
                        }

                    }
                    .ignoresSafeArea(.all)
                    
                }
                
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Picker("Ratio", selection: $brewRatio) {
                            ForEach(1..<(brewRatio)) {
                                Text("1:\($0)")
                            }
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
