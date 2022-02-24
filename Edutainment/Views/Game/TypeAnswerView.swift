//
//  TypeAnswerView.swift
//  Edutainment
//
//  Created by Andres camilo Raigoza misas on 22/02/22.
//

import SwiftUI

struct TypeAnswerView: View {
    @EnvironmentObject var vm: ContentModel
    
    @State private var userAnswer = ""
    @State private var userAnsweredRight: Bool?
    @State private var animateAnswer = false
    
    @State private var showLogo = false
    @State private var animateLogo = false
    @State private var showWrongAnswerCard = false
    
    @FocusState private var keyboardIsFocused
    
    var multiplication: String {
        "\(vm.multiplicandSelected) x \(vm.multiplier)"
    }
    var correctAnswer: Int {
        vm.multiplicandSelected * vm.multiplier
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.theme.background.ignoresSafeArea()
            
            VStack {
                title
                multiplicationCard
                    .padding(.bottom, 30)
                if showLogo {
                    logo.transition(.scale.animation(.spring()))
                }
                Spacer()
            }
            .padding()
            
            if showWrongAnswerCard {
                WrongAnswerCard(
                    multiplication: multiplication,
                    answer: correctAnswer)
                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle("Question \(vm.currentQuestion)/\(vm.numberOfQuestions)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    checkAnswer()
                    keyboardIsFocused = false
                }
            }
        }
        .onChange(of: userAnswer) { newValue in
            if newValue.count > 3 {
                let array = Array(userAnswer)
                userAnswer = String(array.dropLast())
            }
        }
    }
}

struct TypeAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TypeAnswerView()
        }
        .environmentObject(ContentModel())
    }
}

extension TypeAnswerView {
    private var title: some View {
        Text("Type the answer")
            .font(.largeTitle.weight(.semibold))
            .padding(5)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var multiplicationCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .shadow(radius: 3)
            multiplicationView
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .padding()
    }
    private var multiplicationView: some View {
        VStack(spacing: 0) {
            Text(multiplication)
                .font(.system(size: 60, weight: .semibold, design: .default))
            
            Text("=")
                .font(.system(size: 60, weight: .semibold, design: .default))
                .padding(.bottom, 15)
            
            TextField("##", text: $userAnswer)
                .padding(7)
                .font(.system(size: 45, weight: .semibold, design: .default))
                .multilineTextAlignment(.center)
                .frame(width: 110)
                .background(userAnsweredRight == nil ? .clear : userAnsweredRight! ? .green : .red)
                .foregroundColor(userAnsweredRight == nil ? .black : .white)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 0.4)
                }
                .padding(.bottom)
                .scaleEffect(animateAnswer ? 1.1 : 1.0)
                .offset(y: animateAnswer ? -10 : 0)
                .animation(.spring(), value: animateAnswer)
                .keyboardType(.numberPad)
                .focused($keyboardIsFocused)
                .disabled(userAnsweredRight != nil)
        }
    }
    private var logo: some View {
        LogoView(animate: $animateLogo)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animateLogo = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        vm.newQuestion()
                    }
                }
            }
    }
}

// MARK: - FUNCTIONS

extension TypeAnswerView {
    private func checkAnswer() {
        userAnsweredRight = Int(userAnswer) == correctAnswer
        animateAnswer = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animateAnswer = false
        }
        if let userAnsweredRight = userAnsweredRight {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if userAnsweredRight {
                    showLogo = true
                } else {
                    withAnimation {
                        showWrongAnswerCard = true
                    }
                }
            }
        }
    }
}
