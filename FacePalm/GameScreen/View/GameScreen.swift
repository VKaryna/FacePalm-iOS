//
//  GameScreen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 04.02.23.
//

import SwiftUI

struct GameScreen: View {
    @EnvironmentObject private var navigation: AppNavigation
    @EnvironmentObject private var gameNotifications: GameNotifications
    @StateObject private var viewModel: GameViewModel
    @State private var showFindGameErrorPopup = false
    @State private var showChooseCardErrorPopup = false
    @State private var showWaitingForOthersPopup = false

    init(gameId: String, playerId: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gameId: gameId, playerId: playerId))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                VStack {
                    readyToGoText
                    MemeImageView(imageName: viewModel.currentRound.round?.meme, roundNumber: viewModel.currentRound.roundNumber, height: geometry.size.height * 0.4)
                    makeYourDecisionText
                }
                .padding(.horizontal, 24)
                cards
            }
        }
        .navigationBarBackButtonHidden()
        .activityIndicator(isInProgress: viewModel.activityIndicator)
        .background(backgroundColor.ignoresSafeArea())
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
        .popup(isPresented: .constant(showWaitingForOthersPopup)) {
            WaitingForOthersPopup(readyPlayersCount: viewModel.checkPlayersReadiness.readyPlayersCount, totalPlayersCount: viewModel.checkPlayersReadiness.totalPlayersCount)
        }
        .popup(isPresented: $showChooseCardErrorPopup) {
            ErrorPopup(isPresented: $showChooseCardErrorPopup, title: "Error 🥲", description: "Something went wrong!", buttonText: "Try again")
                .onDisappear {
                    Task {
                        do {
                            if let card = viewModel.currentPlayer.cardsToDisplay[safe: viewModel.selectedCardIndex] {
                                try await viewModel.chooseCard(cardId: card.id)
                            }
                        } catch {
                            showChooseCardErrorPopup = true
                        }
                    }
                }
        }
        .onReceive(viewModel.$showVoteScreen) { shouldShow in
            if shouldShow {
                navigation.path.append(Screen.vote(
                    gameId: viewModel.game.gameId,
                    playerId: viewModel.playerId)
                )
            }
        }
        .onReceiveWhileVisible(gameNotifications.game) { game in
            viewModel.onGameNotification(game)
        }
        .task {
            do {
                try await viewModel.findGame()
            } catch {
                showFindGameErrorPopup = true
            }
        }
    }
    
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: .cardWidth))]

    private var cards: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.currentPlayer.cardsToDisplay.indices, id: \.self) { index in
                    let card = viewModel.currentPlayer.cardsToDisplay[index]
                    GameCardView(showChooseCardErrorPopup: $showChooseCardErrorPopup, showWaitingForOthersPopup: $showWaitingForOthersPopup, text: card.text, cardIndex: index, cardId: card.id)
                        .environmentObject(viewModel)
                }
            }
            .padding([.horizontal, .bottom], 24)
            .animation(.easeInOut, value: viewModel.currentPlayer.cardsToDisplay)
        }
    }
       
    private var readyToGoText: some View {
        Text("Ready players: \(viewModel.checkPlayersReadiness.readyPlayersCount)/\(viewModel.checkPlayersReadiness.totalPlayersCount)")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.futuraMedium(size: 20))
            .foregroundColor(Color.white)
            .padding(.top, 38)
    }
    
    private var makeYourDecisionText: some View {
        Text("Choose the best caption:")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.futuraMedium(size: 28))
            .foregroundColor(Color.white)

    }
    
    private var backgroundColor: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.fpDarkLila, Color.fpLightLila]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        return GameScreen(gameId: "124", playerId: 1)
    }
}
