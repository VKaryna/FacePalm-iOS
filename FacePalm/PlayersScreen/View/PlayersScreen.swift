//
//  PlayersScreen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 02.02.23.
//

import SwiftUI

struct PlayersScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigation: AppNavigation
    @StateObject private var viewModel: PlayersViewModel
    @State private var showJoinGamePopup = false
    @State private var showReadyToGoButton = true
    @State private var showWaitingForOwnerStartPopup = false
    @State private var showWaitingMorePlayersPopup = false
    @State private var showWaitingAllReadyPopup = false
    @State private var showDefaultErrorPopup = false
    
    init(gameId: String) {
        _viewModel = StateObject(wrappedValue: PlayersViewModel(gameId: gameId))
    }

    let columns = [
        GridItem(.fixed(30), spacing: 5, alignment: .top),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack(spacing: 36) {
                titleView
                playersListView
                if viewModel.shouldShowStartButton {
                    startButton
                } else {
                    readyToGoButton
                }
            }
            .padding(.vertical, 16)
            .background(Color.fpCream)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .popup(isPresented: $showJoinGamePopup) {
            JoinGamePopup(isPresented: $showJoinGamePopup, showDefaultErrorPopup: $showDefaultErrorPopup)
                .environmentObject(viewModel)
        }
        .popup(isPresented: $showWaitingMorePlayersPopup) {
            WaitingMorePlayersPopup(isPresented: $showWaitingMorePlayersPopup, playersCount: viewModel.game.players.count)
        }
        .popup(isPresented: $showWaitingAllReadyPopup) {
            WaitingAllReadyPopup(isPresented: $showWaitingAllReadyPopup)
        }
        .popup(isPresented: $showWaitingForOwnerStartPopup) {
            WaitingForOwnerStartPopup(isPresented: $showWaitingForOwnerStartPopup)
        }
        .popup(isPresented: $showDefaultErrorPopup) {
            ErrorPopup(isPresented: $showDefaultErrorPopup, title: "Error 🥲", description: "Something went wrong!", buttonText: "Ok")
                .onDisappear(perform: dismiss.callAsFunction)
        }
        .onReceive(viewModel.$showGameScreen) { shouldShow in
            if shouldShow == true {
                navigation.path.append(Screen.game(
                    gameId: viewModel.game.gameId,
                    playerId: viewModel.playerId)
                )
            }
        }
        .onAppear {
            showJoinGamePopup = true
        }
        .onDisappear {
            viewModel.unsubscribeFromGameUpdates()
        }
    }
    
    private var playersListView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.game.players.indices, id: \.self) { index in
                    let player = viewModel.game.players[index]
                    playerIndexView(at: index, for: player.id)
                    playerView(for: player)
                }
            }
            .padding(.leading)
        }
        .frame(maxHeight: 380)
        .animation(.easeInOut, value: viewModel.game.players)
    }
    
    private func playerIndexView(at index: Int, for playerId: Int) -> some View {
        Text("\(index + 1).")
            .font(.futuraMedium(size: 20))
            .fontWeight(viewModel.playerId == playerId ? .medium : .regular)
    }
    
    private func playerView(for player: Player) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                playerNameView(for: player)
                Spacer()
                isPlayerReadyView(isReady: player.isReady)
            }
            Divider()
        }
    }
    
    private func playerNameView(for player: Player) -> some View {
        Text(player.name)
            .font(.futuraMedium(size: 20))
            .fontWeight(viewModel.playerId == player.id ? .medium : .regular)
        +
        Text("\(viewModel.game.ownerId == player.id ? "  (Owner)" : "")")
            .font(.futuraMedium(size: 20))
            .foregroundColor(.gray)
    }
    
    private func isPlayerReadyView(isReady: Bool) -> some View {
        Text("\(isReady ? "✅" : "☑️")")
            .font(.system(size: 23))
            .padding(.trailing, 20)
    }
    
    private var titleView: some View {
        Text("Players:")
            .font(.futuraMedium(size: 26))
    }
    
    private var startButton: some View {
        LoadingButton {
            if viewModel.isNotEnoughPlayers {
                showWaitingMorePlayersPopup = true
            } else if !viewModel.isAllUsersReady {
                showWaitingAllReadyPopup = true
            } else {
                do {
                    try await viewModel.startGame()
                } catch {
                    showDefaultErrorPopup = true
                }
            }
        } label: {
            Text("Start")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
    
    private var readyToGoButton: some View {
        LoadingButton {
            do {
                try await viewModel.becomeReady()
                showReadyToGoButton = false
                showWaitingForOwnerStartPopup = true
            } catch {
                showDefaultErrorPopup = true
            }
        } label: {
            Text("Ready to go")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
        .opacity(showReadyToGoButton ? 1 : 0)
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

struct PlayersScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlayersScreen(gameId: "101")
    }
}
