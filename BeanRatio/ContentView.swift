//
//  ContentView.swift
//  BeanRatio
//
//  Created by Sam Burkhard on 10/21/21.
//

import SwiftUI
import UIKit

// Custom color
extension Color {
    static let customBrown = Color(red: 91 / 255, green: 79 / 255, blue: 65 / 255)
}

struct ContentView: View {
    
    init() {
            UITableView.appearance().backgroundColor = .clear
    }
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    @State var waterAmount = ""
    @State var coffeeAmount = ""
    @State var brewMethod = "Chemex"
    
    @State private var isShowingSettings = false
    
    @State private var brewType = 1
        
    var body: some View {
        NavigationView {
            ZStack {
                
                Rectangle()
                    .ignoresSafeArea()
//                    .foregroundColor(Color.customBrown)
                    .foregroundColor(Color.black)
                
                VStack {
                    
                    // Coffee Label
                    
                    Text("55")
                        .foregroundColor(.white)
                        .font(.system(size: 100, weight: .semibold))
                        .frame(height: 150, alignment: .bottom)
                    
                    Text("grams of coffee")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .regular))
                    
                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .foregroundColor(.white)
                            .opacity(1)
//                            .ignoresSafeArea()
                        
                        VStack() {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(0..<10) { _ in
                                        Circle()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                            .padding(.top, 30)
                            .padding(.leading, 10)
                                                        
                            List {
                                Section(header: Text("Custom").font(.headline)) {
                                    TextField("Water Amount", text: $waterAmount)
                                        .keyboardType(.decimalPad)
                                    
                                    Picker("Units", selection: $brewMethod) {
                                        Text("Grams")
                                        Text("Fl. Ounces")
                                    }.pickerStyle(.segmented)
                                    
                                    Picker("Ratio", selection: $brewMethod) {
                                        Text("1:17")
                                        Text("1:14")
                                    }.pickerStyle(.menu)
                        
                                }
                            }
                            .listStyle(.inset)
                        }
                    }
                    .ignoresSafeArea()
                    .frame(height: 450)
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
            List {
                Text("Settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
