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
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                TextField("Name", text: $title)
            }
            
            Section(header: Text("Ratio")) {
                Stepper("1:\(brewRatio)", value: $brewRatio, in: 1...50, step: 1)
            }
        }
        .listStyle(.grouped)
        .navigationTitle("New Method")
        .toolbar {

            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Add")
            }
        }
}
}

struct NewBrewMethod_Previews: PreviewProvider {
    static var previews: some View {
        NewBrewMethod(title: "Hello", brewRatio: 17)
    }
}
