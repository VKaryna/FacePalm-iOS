//
//  FindGamePopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 02.02.23.
//

import Foundation
import SwiftUI

struct FindGamePopup: View {
    @EnvironmentObject private var navigation: AppNavigation
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    @Binding var showGameNotFoundErrorPopup: Bool
    @Binding var showDefaultErrorPopup: Bool

    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.bottom, 26)
            textFieldView
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 18)
                .padding(.horizontal, 16)
            connectButton
        }
        .onAppear {
            viewModel.gameId = ""
        }
    }
    
    private var textFieldView: some View {
        TextField("Enter game id", text: $viewModel.gameId)
            .autocapitalization(.none)
    }
    
    private var titleView: some View {
        Text("Find game 🔍")
            .font(.futuraMedium(size: 20))
    }
    
    private var connectButton: some View {
        LoadingButton() {
            do {
                try await viewModel.findGame()
                navigation.path.append(Screen.players(gameId: viewModel.gameId))
            } catch is GameNotFoundError {
                showGameNotFoundErrorPopup = true
            } catch {
                showDefaultErrorPopup = true
            }
            isPresented = false
        } label: {
            Text("Connect")
        }
        .disabled(viewModel.gameId.isEmpty)
        .opacity(viewModel.gameId.isEmpty ? 0.5 : 1)
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
}

struct FindGamePopup_Previews: PreviewProvider {
    static var previews: some View {
        FindGamePopup(isPresented: .constant(true), showGameNotFoundErrorPopup: .constant(false), showDefaultErrorPopup: .constant(false))
            .environmentObject(HomeViewModel())
    }
}
