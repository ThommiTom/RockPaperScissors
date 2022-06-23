//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Thomas Schatton on 11.04.22.
//

import SwiftUI

struct ContentView: View {
    @State private var showMatchReport = false
    @State private var showGameOverReport = false
    
    @State private var appsChoice = "🪨"
    @State private var userChoice = ""
    @State private var shouldWin = Bool.random()

    @State private var currentRound = 0
    @State private var score = 0
    @State private var message = ""
    
    private let maxRoundPerGame = 10
    private let rockPaperScissors = ["🪨", "📄", "✂️"]
    private let winningMoves = ["📄" , "✂️", "🪨"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.indigo, .blue, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text(shouldWin ? "WIN" : " LOOSE")
                    .foregroundStyle(.primary)
                    .font(.system(size: 60, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                
                Text("against")
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                VStack(spacing: 20) {
                    ZStack{
                        Circle()
                            .stroke(.ultraThickMaterial, lineWidth: 1)
                            .frame(width: 90, height: 90)
                            
                        Text(appsChoice)
                            .font(.system(size: 60))
                    }
                    
                    Text("VS")
                        .font(.system(size: 40, weight: .heavy, design: .default))
                        .opacity(0.7)
                    
                    ZStack{
                        Circle()
                            .stroke(.ultraThickMaterial, lineWidth: 1)
                            .frame(width: 90, height: 90)
                            
                        Text(userChoice)
                            .font(.system(size: 60))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                
                Text("Your score: \(score)")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                HStack {
                    ForEach(rockPaperScissors, id: \.self) { selection in
                        Button {
                            userChoice = selection
                            checkRound()
                        } label: {
                            Text(selection)
                                .font(.system(size: 60))
                        }
                        .buttonStyle(.bordered)
                        .background(LinearGradient(colors: [.indigo, .cyan, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    }
                    
                }
            }
            .padding()
        }
        .alert("Round Report", isPresented: $showMatchReport) {
            Button("Continue") {
                if currentRound < maxRoundPerGame {
                    resetRound()
                }
                checkGameProgression()
            }
        } message: {
            Text(message)
        }
        .alert("Game Over", isPresented: $showGameOverReport) {
            Button("Restart") {
                resetGame()
            }
        }
    }
      
    func appMakesChoice() {
        appsChoice = rockPaperScissors.shuffled().first!
    }
        
    func checkRound() {
        var didWin: Bool?
        guard let index = rockPaperScissors.firstIndex(of: appsChoice) else {
            return
        }
        
        if rockPaperScissors[index] == userChoice {
            didWin = nil
        } else if winningMoves[index] == userChoice {
            didWin = true
        } else {
            didWin = false
        }
        
        guard let hadWon = didWin else {
            message = "Draw"
            currentRound += 1
            showMatchReport = true
            return
        }
        
        if hadWon == shouldWin {
            message = "Correct"
            score += 10
        } else {
            message = "Wrong"
            score -= 10
        }
        
        currentRound += 1
        showMatchReport = true
    }
    
    func resetRound() {
        shouldWin = Bool.random()
        appMakesChoice()
        userChoice = ""
    }
    
    func checkGameProgression() {
        if currentRound == maxRoundPerGame {
            showGameOverReport = true
        }
    }
    
    func resetGame() {
        resetRound()
        currentRound = 0
        score = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
