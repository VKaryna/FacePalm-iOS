//
//  VoteScreen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 09.02.23.
//

import SwiftUI

struct VoteScreen: View {
    @EnvironmentObject private var gameNotifications: GameNotifications
    @StateObject private var viewModel: VoteViewModel
    @State private var showFindGameErrorPopup = false
    @State private var showVoteCardErrorPopup = false
    @State private var showWaitingForOthersPopup = false

    init(gameId: String, playerId: Int) {
        _viewModel = StateObject(wrappedValue: VoteViewModel(gameId: gameId, playerId: playerId))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                VStack {
                    readyToGoText
                    MemeImageView(imageName: viewModel.currentRound.round?.meme, roundNumber: nil, height: geometry.size.height * 0.4)
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
        .popup(isPresented: $showVoteCardErrorPopup) {
            ErrorPopup(isPresented: $showVoteCardErrorPopup, title: "Error 🥲", description: "Something went wrong!", buttonText: "Try again")
                .onDisappear {
                    Task {
                        do {
                            if let card = viewModel.voteCards.cardsToDisplay[safe: viewModel.selectedCardIndex] {
                                try await viewModel.voteCard(cardId: card.id)
                            }
                        } catch {
                            showVoteCardErrorPopup = true
                        }
                    }
                }
        }
        .onReceive(gameNotifications.game) { game in
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
                ForEach(viewModel.voteCards.cardsToDisplay.indices, id: \.self) { index in
                    let card = viewModel.voteCards.cardsToDisplay[index]
                    VoteCardView(showVoteCardErrorPopup: $showVoteCardErrorPopup, showWaitingForOthersPopup: $showWaitingForOthersPopup, text: card.text, cardIndex: index, cardId: card.id)
                        .environmentObject(viewModel)
                }
            }
            .padding([.horizontal, .bottom], 24)
            .animation(.easeInOut, value: viewModel.currentPlayer.cardsToDisplay)
        }
    }
       
    private var readyToGoText: some View {
        Text("Ready to go: \(viewModel.checkPlayersReadiness.readyPlayersCount)/\(viewModel.checkPlayersReadiness.totalPlayersCount)")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.futuraMedium(size: 20))
            .foregroundColor(Color.white)
            .padding(.top, 38)
    }
    
    private var makeYourDecisionText: some View {
        Text("Vote for the best caption:")
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

struct VoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        VoteScreen(gameId: "101", playerId: 2)
    }
}
