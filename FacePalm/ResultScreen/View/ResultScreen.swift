//
//  ResultScreen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 10.02.23.
//

import SwiftUI

struct ResultScreen: View {
    @EnvironmentObject private var navigation: AppNavigation
    @EnvironmentObject private var gameNotifications: GameNotifications
    @StateObject private var viewModel: ResultViewModel
    @State private var showGameWinnersPopup = false
    @State private var showWinnersPopup = false
    @State private var showFindGameErrorPopup = false
    @State private var showNextRoundErrorPopup = false
    
    init(gameId: String, playerId: Int) {
        _viewModel = StateObject(wrappedValue: ResultViewModel(gameId: gameId, playerId: playerId))
    }

    let columns = [
        GridItem(.fixed(30), spacing: 5, alignment: .top),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 36) {
            titleView
            playersListView
            if viewModel.shouldShowContinueButton {
                continueButton
            }
        }
        .padding(.vertical, 16)
        .background(Color.fpCream)
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .activityIndicator(isInProgress: viewModel.activityIndicator)
        .background(backgroundColor)
        .popup(isPresented: $showFindGameErrorPopup) {
            ErrorPopup(isPresented: $showFindGameErrorPopup, title: "Error 🥲", description: "Something went wrong!", buttonText: "Try again")
                .onDisappear {
                    Task {
                        do {
                            try await viewModel.findGame()
                        } catch {
                            showFindGameErrorPopup = true
                        }
                    }
                }
        }
        .popup(isPresented: $showWinnersPopup) {
            WinnersPopup(isPresented: $showWinnersPopup, winners: viewModel.currentRound.winners)
                .onDisappear {
                    showWinnersPopup = false
                    if (viewModel.isTheLastRound) {
                        showGameWinnersPopup = true
                    }
                }
        }
        .popup(isPresented: $showGameWinnersPopup) {
            GameWinnersPopup(isPresented: $showGameWinnersPopup, winners: viewModel.gameWinners)
                .onDisappear {
                    showGameWinnersPopup = false
                }
        }
        .popup(isPresented: $showNextRoundErrorPopup) {
            ErrorPopup(isPresented: $showFindGameErrorPopup, title: "Error 🥲", description: "Something went wrong!", buttonText: "Try again")
                .onDisappear {
                    Task {
                        do {
                            try await viewModel.moveToNextRound()
                        } catch {
                            showNextRoundErrorPopup = true
                        }
                    }
                }
        }
        .onReceive(viewModel.$showHomeScreen) { shouldShow in
            if shouldShow {
                navigation.path = [.home]
            }
        }
        .onReceive(viewModel.$showGameScreen) { shouldShow in
            if shouldShow {
                navigation.path.append(.game(gameId: viewModel.game.gameId, playerId: viewModel.playerId))
            }
        }
        .onReceiveWhileVisible(gameNotifications.game) { game in
            viewModel.onGameNotifications(game)
        }
        .task {
            do {
                try await viewModel.findGame()
                showWinnersPopup = true
            } catch {
                showFindGameErrorPopup = true
            }
        }
    }
    
    private var playersListView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.sortedPlayers.indices, id: \.self) { index in
                    playerView(at: index)
                    playerResultView(for: viewModel.sortedPlayers[index], with: index)
                }
            }
            .padding(.leading)
        }
        .frame(maxHeight: 380)
        .animation(.easeInOut, value: viewModel.game.players)
    }
    
    private func playerView(at index: Int) -> some View {
        Text("\(index + 1).")
            .font(.futuraMedium(size: 20))
    }
    
    private func playerResultView(for player: Player, with index: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                playerNameView(player: player, index: index)
                Spacer()
                playerTotalPointsView(for: player.id)
            }
            Divider()
        }
    }
    
    private func playerNameView(player: Player, index: Int) -> some View {
        Text(player.name)
            .font(.futuraMedium(size: 20))
        +
        Text("  \(viewModel.isTheLastRound && viewModel.gameWinners.contains(player) ? "👑" : "")")
            .font(.system(size: 23))
    }
    
    private func playerTotalPointsView(for playerId: Int) -> some View {
        Text("\(viewModel.getTotalPoints(for: playerId))")
            .font(.futuraMedium(size: 20))
            .padding(.trailing, 20)
    }
    
    private var titleView: some View {
        Text("Players:")
            .font(.futuraMedium(size: 26))
    }
    
    private var continueButton: some View {
        LoadingButton {
            if viewModel.isCurrentPlayerOwner {
                do {
                    try await viewModel.moveToNextRound()
                } catch {
                    showNextRoundErrorPopup = true
                }
            } else {
                gameNotifications.unsubscribeFromGameUpdates()
                viewModel.showHomeScreen = true
            }
        } label: {
            Text(viewModel.isTheLastRound ? "Finish game" : "Continue")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
    
    private var backgroundColor: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.fpDarkLila, Color.fpLightLila]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct ResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResultScreen(gameId: "101", playerId: 1)
    }
}
