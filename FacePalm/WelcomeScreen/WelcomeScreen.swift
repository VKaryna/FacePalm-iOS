//
//  WelcomeScreen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 01.03.23.
//

import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject private var navigation: AppNavigation
    @StateObject private var gameNotifications = GameNotifications()
    @State private var showGenericErrorPopup = false

    var body: some View {
        NavigationStack(path: $navigation.path) {
            LinearGradient(
                gradient: Gradient(
                    colors: [Color.fpDarkLila, Color.fpLightLila]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .players(let gameId):
                    PlayersScreen(gameId: gameId)
                        .environmentObject(gameNotifications)
                case .game(let gameId, let playerId):
                    GameScreen(gameId: gameId, playerId: playerId)
                        .environmentObject(gameNotifications)
                case .vote(let gameId, let playerId):
                    VoteScreen(gameId: gameId, playerId: playerId)
                        .environmentObject(gameNotifications)
                case .results(let gameId, let playerId):
                    ResultScreen(gameId: gameId, playerId: playerId)
                        .environmentObject(gameNotifications)
                case .home:
                    HomeScreen()
                }
            }
            .popup(isPresented: $showGenericErrorPopup) {
                AppUnavailablePopupView()
            }
            .onAppear {
                navigation.path.append(Screen.home)
            }
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .environmentObject(AppNavigation())
    }
}
