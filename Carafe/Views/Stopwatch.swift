//
//  Stopwatch.swift
//  Carafe
//
//  Created by Sam Burkhard on 3/25/22.
//

import SwiftUI

class TimerObject: ObservableObject {
    @Published var timeRemaining: Int = 180
    @Published var totalTime: Int = 180
}

struct Stopwatch: View {
    
    @AppStorage("hapticsOn") var hapticsOn: Bool = true
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var timerObject: TimerObject
    
    @State var timerActive: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showingAlert: Bool = false
    
    // animation for tapping
    @State var tap = false

    var body: some View {
            
        VStack {
            
            ZStack {
                
                Circle()
                    .trim(from: 0, to: 1.0)
                    .rotation(.degrees(270))
                    .stroke(Color(red: 55/255, green: 55/255, blue: 58/255), style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .frame(width: 325, height: 325)
                
                Circle()
                    .trim(from: 0, to: CGFloat(1.0 - (Double(timerObject.timeRemaining) / Double(timerObject.totalTime))))
                    .rotation(.degrees(270))
                    .stroke((colorScheme == .light) ? .orange : .blue, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .frame(width: 325, height: 325)
                
                VStack {
                    
                    Text("\(timerObject.timeRemaining / 60):\((timerObject.timeRemaining % 60 == 0) ? "00" : String(timerObject.timeRemaining % 60))").font(.system(size: 90, weight: .medium)).foregroundColor(.white)
                        .padding(.bottom, 1)
                    
                        // MARK: Receieve Timer Info
                        .onReceive(timer) { _ in
                            if (timerActive) {
                                if (timerObject.timeRemaining != 0) {
                                    withAnimation {
                                        timerObject.timeRemaining -= 1
                                    }
                                } else {
                                    timerActive = false
                                }
                            }
                        }
                    
                    ZStack {
                        
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(red: 55/255, green: 55/255, blue: 58/255))
                        
                        Image(systemName: (timerActive) ? "pause.fill": (timerObject.timeRemaining == 0) ? "arrow.clockwise": "play.fill").scaleEffect(3)
                            .foregroundColor((colorScheme == .light) ? .orange : .blue)
                    }
                    
                    .onTapGesture {
                        if (hapticsOn) {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                        }
                        
                        if (timerActive) {
                            withAnimation {
                                timerActive = false
                            }
                        } else {
                            
                            withAnimation {
                                timerActive = true
                            }
                            
                            if (timerObject.timeRemaining == 0) {
                                timerObject.timeRemaining = timerObject.totalTime
                            }
                            
                        }
                        
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
            
            Button(action: {
                showingAlert = true
            }) {
                Text("Reset").foregroundColor(.red)
                    .padding()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Reset this timer?"), message: Text("You can always start another one"),
                  primaryButton: .default(
                    Text("Cancel"),
                    action: { showingAlert = false }
                  ),
                  secondaryButton: .destructive(
                    Text("Reset"),
                    action: {
                        showingAlert = false
                        timerObject.timeRemaining = timerObject.totalTime
                    }
                  ))
        }
    }
}

struct Stopwatch_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Stopwatch(timerObject: TimerObject())
        }
    }
}
