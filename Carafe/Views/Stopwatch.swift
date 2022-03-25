//
//  Stopwatch.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/25/22.
//

import SwiftUI

struct Stopwatch: View {
    var body: some View {
            
        VStack {
            ZStack {
                
                Circle()
                    .trim(from: 0, to: 0.85)
                    .rotation(.degrees(270))
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 350, height: 350)
                
                VStack {
                    
                    Text("0:24").font(.system(size: 100, weight: .medium)).foregroundColor(.white)
                        .padding(.bottom, 1)
                    
                    Button(action: {
                        print("Started Timer")
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color(red: 55/255, green: 55/255, blue: 58/255))
                            
                            Image(systemName: "play.fill").scaleEffect(3)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            
            Button(action: {
                print("Reset Timer")
            }) {
                Text("Reset").foregroundColor(.red)
                    .padding()
            }
        }
    }
}

struct Stopwatch_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Stopwatch()
        }
    }
}
