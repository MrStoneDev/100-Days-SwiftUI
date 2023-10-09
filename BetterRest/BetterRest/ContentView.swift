//
//  ContentView.swift
//  BetterRest
//
//  Created by Mario Alvarado on 03/09/23.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var sleepTime = defaultBedTime
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    static var defaultBedTime : Date {
        var components = DateComponents()
        components.hour = 22
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Coffee cutoff time")
                    .font(.headline)
                
                Spacer()
                
                Text("\(sleepTime.formatted(date: .omitted, time: .shortened))")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
                
                Form {
                    Section(
                        header:
                            Text("☀️ When do you want to wake up?").textCase(nil)
                            .font(.headline)
                    ) {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: wakeUp) { newValue in
                                calculateBedtime()
                            }
                    }
                    .datePickerStyle(WheelDatePickerStyle())
                    
                    Section(
                        header:
                            Text("🛌  Desired amount of sleep").textCase(nil)
                            .font(.headline)
                    ) {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                            .onChange(of: sleepAmount) { newValue in
                                calculateBedtime()
                            }
                    }
                    
                    Section(
                        header:
                            Text("☕️  Daily coffee intake").textCase(nil)
                            .font(.headline)
                    ) {
                        Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                            ForEach(1..<21, id: \.self) { cup in
                                Text("\(cup)")
                            }
                            .onChange(of: coffeeAmount) { newValue in
                                calculateBedtime()
                            }
                        }
                        
                    }
                }
                .navigationTitle(
                    Text("BetterRest")
                )
            }
        }
    }
    
    
    func calculateBedtime(){
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60 * 60
            
            let prediction = try model.prediction(wake: Double(hour * minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            sleepTime = wakeUp - prediction.actualSleep
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
