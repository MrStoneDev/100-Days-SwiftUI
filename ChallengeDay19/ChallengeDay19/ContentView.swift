//
//  ContentView.swift
//  ChallengeDay19
//
//  Created by Mario Alvarado on 25/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var inputAmount = 0.0
    @State private var inputUnit = "m"
    @State private var outputUnit = "m"
    @FocusState private var conversionIsFocused: Bool
    
    private var units = ["m", "km", "ft", "yd", "mi"]
    
    var conversion: Double {
        let conversionFactors: [String: Double] = [
            "m": 1.0,
            "km": 0.001,
            "ft": 3.281,
            "yd": 1.094,
            "mi": 0.000621371
        ]
            
        guard let inputFactor = conversionFactors[inputUnit],
              let outputFactor = conversionFactors[outputUnit] else {
            return 0.0 // Handle invalid units
        }
        
        return inputAmount * (outputFactor / inputFactor)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("input", value: $inputAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($conversionIsFocused)
                    
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("From")
                }
                
                Section {
                    Text(conversion, format: .number)
                    
                    Picker("Output unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("To")
                }
            }
            .navigationTitle("LengthConv")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
