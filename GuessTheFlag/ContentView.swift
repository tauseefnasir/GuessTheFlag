//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nasir on 10/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    enum ScoreTitleType: String {
        case Correct, Wrong
    }
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "US", "Ukraine"]
    @State private var correctFlag = Int.random(in: 0...2)
    @State private var scoreTitle = ScoreTitleType.Wrong
    @State private var showScoreMessage = false
    @State private var userGuessed = 0
    @State private var score = 0
    @State private var won = false
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: .blue.opacity(0.9), location: 0.34),
                Gradient.Stop(color: .pink.opacity(0.7), location: 0.34)], center: .topLeading, startRadius: 95, endRadius: 900)
            RadialGradient(stops: [
                Gradient.Stop(color: .mint.opacity(0.7), location: 0.64),
                Gradient.Stop(color: .pink.opacity(0.0), location: 0.34)], center: .bottomTrailing, startRadius: 25, endRadius: 400)
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline.weight(.semibold))
                    Text("\(countries[correctFlag])")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.secondary)
                    ForEach(0..<3) { number in
                        Button {
                                flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.buttonBorder)
                                .shadow(radius: 3)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Text("Score: \(score)")
                    .font(.title2.bold())
            }
            .padding()
        }
        .alert(String(scoreTitle.rawValue), isPresented: $showScoreMessage, presenting: scoreTitle) {_ in
            Button("Continue", action: newQuestion)
        } message: { _ in
            
            switch scoreTitle {
            case .Correct:
                Text("Hurrah! you guessed right")
            case .Wrong:
                Text("This is flag of \(countries[userGuessed])")
            }
           
        }
        .alert("You Won", isPresented: $won, presenting: "Win Message") {_ in
            Button("Restart", action: restartGame)
        } message: { _ in
            Text("Congratulations! You've made the correct guess 30 times. Now, you've successfully memorised these flags.")
        }
        .ignoresSafeArea()
    }
    
    func flagTapped(_ flag:Int) {
        userGuessed = flag
        if flag == correctFlag {
            scoreTitle = .Correct
            score += 1
        } else {
            scoreTitle = .Wrong
            score -= 1
        }
        
        if score == 30 {
            won = true
        } else {
            showScoreMessage = true
        }
       
    }
    
    func restartGame() {
        won = false
        score = 0
        userGuessed = 0
        showScoreMessage = false
        scoreTitle = .Wrong
        newQuestion()
    }
    
    func newQuestion() {
        countries.shuffle()
        correctFlag = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
