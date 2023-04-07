//
//  JoinGamePopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 02.02.23.
//

import SwiftUI

struct JoinGamePopup: View {
    @EnvironmentObject private var viewModel: PlayersViewModel
    @EnvironmentObject private var gameNotifications: GameNotifications
    
    @Binding var isPresented: Bool
    @Binding var showDefaultErrorPopup: Bool
    
    @State private var playerName: String = ""
    @State private var showErrorMessage = false

    var body: some View {
        VStack(spacing: 0) {
            titleView
            VStack(alignment: .leading, spacing: 2) {
                textFieldView
                errorMessageView
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 18)
            joinButton
        }
    }
    
    private var textFieldView: some View {
        TextField("Enter your name", text: $playerName)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.namePhonePad)
            .textContentType(.nickname)
    }
    
    private var titleView: some View {
        Text("Your name:")
            .font(.futuraMedium(size: 20))
            .padding(.bottom, 26)
    }
    
    private var errorMessageView: some View {
        Text("User with this name already exists.")
            .font(.futuraMedium(size: 14))
            .foregroundColor(Color.red)
            .opacity(showErrorMessage ? 0.8 : 0)
            .padding(.leading, 2)
    }
    
    private var joinButton: some View {
        LoadingButton() {
            do {
                try await viewModel.joinGame(playerName: playerName)
                gameNotifications.subscribeToGameUpdates()
                isPresented = false
            } catch is UserAlreadyExistsError {
                showErrorMessage = true
            } catch {
                showDefaultErrorPopup = true
                isPresented = false
            }
        } label: {
            Text("Join")
        }
        .disabled(playerName.isEmpty)
        .opacity(playerName.isEmpty ? 0.5 : 1)
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
}

struct JoinGamePopup_Previews: PreviewProvider {
    static var previews: some View {
        JoinGamePopup(isPresented: .constant(true), showDefaultErrorPopup: .constant(false))
            .environmentObject(PlayersViewModel(gameId: "32"))
    }
}
