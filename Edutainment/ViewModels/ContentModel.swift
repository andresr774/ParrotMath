//
//  ViewModel.swift
//  Edutainment
//
//  Created by Andres camilo Raigoza misas on 18/02/22.
//

import Foundation
import SwiftUI

class ContentModel: ObservableObject {
    
    @Published var settingsMode = true
    @Published var multiplicandSelected = Int.random(in: 2...10)
    @Published var levelSelected: Level = .normal
    
    @Published var numberOfQuestions = 10
    @Published var currentQuestion = 1
    
    private var multiplierOptions = Set(2...10)
    @Published var multiplier = 2
    
    private var userAnswers = [Int:Bool]()
    
    private var screens = TypeOfScreen.allCases
    @Published var screenShowing: TypeOfScreen = .decideGame
    private var screenShowingIndex = 0
        
    func startGame() {
        switch levelSelected {
        case .easy:
            numberOfQuestions = 5
        case .normal:
            numberOfQuestions = 10
        case .expert:
            numberOfQuestions = 20
        }
        withAnimation {
            settingsMode = false
        }
    }
    func newQuestion() {
        if userAnswers.isNotEmpty {
            updateScreenShowing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateCurrentQuestion()
            }
        }
        if currentQuestion < numberOfQuestions {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateMultiplier()
            }
        }
    }
    private func updateMultiplier() {
        if multiplierOptions.isNotEmpty {
            multiplier = multiplierOptions.randomElement() ?? 0
            print("[👉🏻] Multiplier options: \(multiplierOptions)")
            print("[👉🏻] Multiplier chosen: \(multiplier)")
            multiplierOptions.remove(multiplier)
        } else {
            let multiplicationsToReview = userAnswers.filter { !$0.value }
            if multiplicationsToReview.count > 0 {
                // There's multiplications to review
                let multipliersToReview = multiplicationsToReview.map { $0.key }
                multiplierOptions = Set(multipliersToReview)
                print("[👉🏻] Multiplier options to review: \(multiplierOptions)")
                multiplier = multiplierOptions.randomElement() ?? 0
                print("[👉🏻] Multiplier to review chosen: \(multiplier)")
                multiplierOptions.remove(multiplier)
            } else {
                // There's no multiplications to review so fill multiplier options again
                multiplierOptions = Set(2...10)
                multiplier = multiplierOptions.randomElement() ?? 0
                multiplierOptions.remove(multiplier)
            }
        }
    }
    private func updateScreenShowing() {
        // Check if it's last question
        if currentQuestion == numberOfQuestions {
            screenShowingIndex = screens.count - 1
        } else {
            let currentIndex = screens.firstIndex(of: screenShowing) ?? 0
            if currentIndex < screens.count - 2 {
                screenShowingIndex += 1
            } else {
                screenShowingIndex = 0
            }
        }
        withAnimation {
            screenShowing = screens[screenShowingIndex]
        }
    }
    private func updateCurrentQuestion() {
        if currentQuestion < numberOfQuestions {
            currentQuestion += 1
        } else {
            currentQuestion = 1
        }
    }
    func saveAnswer(userAnsweredRight: Bool) {
        userAnswers[multiplier] = userAnsweredRight
        print("[👉🏻] user answers: \(userAnswers)")
        if !userAnsweredRight {
            self.numberOfQuestions += 1
        }
    }
    func playAgain() {
        multiplierOptions = Set(2...10)
        userAnswers = [Int:Bool]()
        settingsMode = true
        screenShowing = .decideGame
    }
}
