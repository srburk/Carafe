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
    
    @StateObject var mainStore: Store
    @StateObject var amountObject: AmountObject
    @StateObject var timerObject: TimerObject
    
    @AppStorage("hapticsOn") var hapticsOn: Bool = true
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    
    @AppStorage("waterPreset1") var waterPreset1: Double = 350;
    @AppStorage("waterPreset2") var waterPreset2: Double = 450;
    @AppStorage("waterPreset3") var waterPreset3: Double = 600;
    
    @Binding var selectedBrewMethod: BrewMethod?
    
    // MARK: Feedback Info
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    let appVersion = "1.0"
    
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
                Section(header: Text("Brewing Methods"), footer: Text("Save ratios for your favorite brewing methods")) {
                    
                    ForEach($mainStore.storage.brewMethods) { $brewMethod in
                        
                        let systemImage = (selectedBrewMethod?.id == brewMethod.id) ? "checkmark.circle.fill" : "circle"
                        
                        HStack {
                            Label("\(brewMethod.title)", systemImage: systemImage).foregroundColor(.primary)
                            Spacer()
                            Text("1:\(brewMethod.brewRatio)")
                                .foregroundColor(.secondary)
                        }
                        .onTapGesture {
                            selectedBrewMethod = brewMethod
                            mainStore.storage.defaults.defaultBrewMethod = selectedBrewMethod
                            amountObject.brewRatio = selectedBrewMethod?.brewRatio ?? 17
                        }
                        
                    }
                    
                    .onDelete(perform: delete)

                    NavigationLink("New Method", destination: NewBrewMethod(title: "", brewRatio: 15, mainStore: mainStore, selectedBrewMethod: $selectedBrewMethod, presentationMode: self._presentationMode)).foregroundColor(.blue)
                }
                
                Section {
                    
                    // MARK: THEME
                    NavigationLink(destination: {
                        List {
                            Section {
                                Toggle(isOn: $useDarkMode, label: {
                                    Text("Always Use Dark Mode")
                                })
                            }
                            Section(header: Text("Light Accent")) {
                                Text("Color")
                            }
                            Section(header: Text("Dark Accent")) {
                                Text("Color")
                            }
                        }
                        .navigationBarTitle("Theme")
                    }) {
                        Label("Theme", systemImage: "paintbrush")
                            .foregroundColor(.primary)
                    }
                                        
                    Picker(selection: $mainStore.storage.defaults.defaultUnits, label: Label("Default Units", systemImage: "scalemass").foregroundColor(.primary)) {
                        Text("Grams").tag(Units.grams)
                        Text("Ounces").tag(Units.ounces)
                            .navigationBarTitle(Text("Units"))
//                            .navigationBarTitleDisplayMode(.inline)
                    }

                    NavigationLink(destination: {
                        List {
                            Section(header: Text("Preset 1"), footer: Text("Water presets use your default units")) {
                                TextField("Water Preset", value: $waterPreset1, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                            }
                            Section(header: Text("Preset 2"), footer: Text("Water presets use your default units")) {
                                TextField("Water Preset", value: $waterPreset2, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                            }
                            Section(header: Text("Preset 3"), footer: Text("Water presets use your default units")) {
                                TextField("Water Preset", value: $waterPreset3, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                            }
                        }
                        .navigationBarTitle("Water Presets")
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }) {
                        Label("Water Presets", systemImage: "drop")
                    }.foregroundColor(.primary)
                    
                    Toggle(isOn: $hapticsOn) {
                        Label("Haptic Feedback", systemImage: "hand.tap")
                    }.foregroundColor(.primary)
                    
                }
                
                Section(header: Text("Feedback")) {
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/carafe/id1615607237")!)
                    }) {
                        Label("Rate App", systemImage: "star").foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "mailto:burkhas4@mail.uc.edu?subject=Carafe%20Feedback&body=%0D%0A%0D%0A---------------%0D%0AOS%3A%20\(UIDevice.current.systemName)%20\(UIDevice.current.systemVersion)%0D%0ADevice%3A%20\(UIDevice.current.localizedModel)%0D%0AApp%20Version%3A%20\(appName)%20\(appVersion)")!)
                    }) {
                        Label("Send Feedback", systemImage: "envelope").foregroundColor(.primary)
                    }
                }
                
                // MARK: Feedback and About
                Section {
                    
                    NavigationLink(destination: Help()) {
                        Label("Help", systemImage: "person.fill.questionmark")
                    }.foregroundColor(.primary)
                    
                    NavigationLink(destination: About()) {
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
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onChange(of: selectedBrewMethod?.title) { newValue in
            amountObject.selectedUnit = mainStore.storage.defaults.defaultUnits
            timerObject.totalTime = selectedBrewMethod?.timerAmount ?? 180
            timerObject.timeRemaining = selectedBrewMethod?.timerAmount ?? 180
        }
        
        .onDisappear {
   
            Store.save(storage: mainStore.storage) { result in
                if case .failure(let error) = result {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    
    static var previews: some View {
        Settings(mainStore: Store(), amountObject: AmountObject(), timerObject: TimerObject(), selectedBrewMethod: .constant(BrewMethod(id: UUID(), title: "Chemex", brewRatio: 17)))
    }
}
