//
//  About.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/21/22.
//

import SwiftUI

struct AboutField: View {

    var body: some View {
        Text("It was built by ") +
        Text("Sam Burkhard").fontWeight(.bold).foregroundColor(Color(red: 123/255, green: 104/255, blue: 238/255)) +
        Text(", a Computer Engineering Student at the University of Cincinnati")
    }
    
}

struct About: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 150, height: 150)
//                .padding(.top, 75)
                .cornerRadius(35)
//                .padding(.top, 25)
            Text("Carafe")
                .foregroundColor(.primary)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Divider()
            
            Text("Carafe is a simple coffee ratio calculator for anyone who loves making coffee.")
                .multilineTextAlignment(.leading)
                .padding()
                        
            AboutField()
                .padding()

            Spacer()
        }
//        .navigationTitle("About")
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
