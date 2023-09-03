//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Mario Alvarado on 02/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var choices = ["🗿", "🧻", "✂️"]
    @State private var round = 1
    @State private var score = 0
    @State private var gameOver = false
    
    @State private var appChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 251 / 255.0, green: 240 / 255.0, blue: 178 / 255.0), Color(red: 255 / 255.0, green: 199 / 255.0, blue: 234 / 255.0)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack (spacing: 20){
                Spacer()
                Text("Opponent's move:")
                    .font(.largeTitle.bold())
                    .foregroundColor(.purple)

                Text(choices[appChoice])
                    .font(.system(size: 200))
            
                if shouldWin {
                    Text("Choose to win:")
                        .font(.largeTitle.bold())
                        .foregroundColor(.purple)
                } else {
                    Text("Choose to lose:")
                        .font(.largeTitle.bold())
                        .foregroundColor(.purple)
                }

                HStack(spacing: 20) {
                    ForEach(0..<3) { number in
                        Button {
                            imageTapped(number)
                        } label: {
                            Text(choices[number])
                                .font(.system(size: 80))
                        }
                    }
                }
                Spacer()
                
                HStack(spacing: 60) {
                    Text("Round: \(round) / 10")
                        .font(.title2.bold())
                        .foregroundColor(.purple)
                    Text("Score: \(score)")
                        .font(.title2.bold())
                        .foregroundColor(.purple)
                }
                
            }
        }
        .alert(scoreTitle, isPresented: $showingAlert) {
            if round < 10 {
                Button("Continue", action: nextRound)
            } else {
                Button("Game Over", action: endGame)
            }
        } message: {
            Text(textAlert)
        }
        
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Start again", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    // Function to handle the player's move
    func imageTapped(_ number: Int) {
        let playerChoice = choices[number]
        
        if (shouldWin && doesPlayerWin(playerChoice)) || (!shouldWin && !doesPlayerWin(playerChoice)) {
            score += 1
            textAlert = shouldWin ? "Correct! \(playerChoice) beats \(choices[appChoice])" : "Correct! \(choices[appChoice]) beats \(playerChoice)"
        } else {
            score -= 1
            textAlert = shouldWin ? "Wrong! \(choices[appChoice]) beats \(playerChoice)" : "Wrong! \(playerChoice) beats \(choices[appChoice])"
        }
        
        if round < 10 {
            showingAlert = true
        } else {
            gameOver = true
        }
    }
    
    // Function to check if the player wins based on their choice
    func doesPlayerWin(_ playerChoice: String) -> Bool {
        switch playerChoice {
        case "🗿":
            return choices[appChoice] == "✂️"
        case "🧻":
            return choices[appChoice] == "🗿"
        case "✂️":
            return choices[appChoice] == "🧻"
        default:
            return false
        }
    }
    
    // Function to start the next round
    func nextRound() {
        round += 1
        appChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
        showingAlert = false
    }
    
    // Function to end the game
    func endGame() {
        gameOver = true
    }
    
    // Function to reset the game
    func reset() {
        round = 1
        score = 0
        appChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
        gameOver = false
    }
    
    var scoreTitle: String {
        round < 10 ? "Round \(round) Result" : "Final Score"
    }
    
    @State private var textAlert = ""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
