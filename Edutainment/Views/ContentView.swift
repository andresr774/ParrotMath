//
//  ContentView.swift
//  Edutainment
//
//  Created by Andres camilo Raigoza misas on 19/02/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ContentModel
    
    var body: some View {
        if vm.settingsMode {
            OnboardingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading))
                )
        }
        if !vm.settingsMode {
            if vm.screenShowing == .decideGame {
                YesOrNoView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading))
                    )
            }
            if vm.screenShowing == .sortGame {
                SortingNumbersView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading))
                    )
            }
            if vm.screenShowing == .typeGame {
                TypeAnswerView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading))
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentModel())
    }
}
