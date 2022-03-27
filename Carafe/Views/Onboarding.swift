//
//  Onboarding.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/20/22.
//

import SwiftUI

struct Onboarding: View {
    
    @AppStorage("needsOnboarding") var needsOnboarding: Bool = true
    
    @State var tap: Bool = false
    
    var body: some View {
            
        ZStack {
            
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.black)
            
            VStack {
                
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, 75)
                
                Text("Carafe")
                    .foregroundColor(.white)
//                    .font(.largeTitle)
                    .font(.custom("PlayfairDisplay-Bold", size: 45))
                    .fontWeight(.semibold)
                
                Text("A simple coffee ratio calculator for enthusiasts")
                    .padding()
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    needsOnboarding = false
                }) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(height: 50)
                            .foregroundColor(.white)
                        Text("Get Started")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                .padding()
                .padding(.bottom, 25)
                .onTapGesture {
                    tap = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        tap = false
                    }
                }
                
                .animation(nil, value: tap)
                .scaleEffect(tap ? 0.85 : 1)
                .animation(.spring(), value: tap)
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
