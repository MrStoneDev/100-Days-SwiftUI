//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mario Alvarado on 26/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var textAlert = ""
    @State private var games = 1
    @State private var gameOver = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .black], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Game \(games)")
                    .foregroundColor(.white)
                    .font(.title3.bold())
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(textAlert)
        }
        
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Start again", action: reset)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            textAlert = "+1 Point!"
            score += 1
        } else {
            scoreTitle = "Wrong!"
            textAlert = "That's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        games += 1
        
        if games == 9 {
            games = 8
            gameOver = true
        }
        
        if gameOver == false {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        games = 1
    }
}

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
