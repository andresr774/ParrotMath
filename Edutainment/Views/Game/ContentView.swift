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
        ZStack {
            if vm.settingsMode {
                OnboardingView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading))
                    )
            }
            if !vm.settingsMode {
                ArrangeNumbersView()
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
