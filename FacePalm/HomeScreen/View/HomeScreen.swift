//
//  HomeScreen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 20.01.23.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showGameCreatedPopup = false
    @State private var showFindGamePopup = false
    @State private var showDefaultErrorPopup = false
    @State private var showGameNotFoundErrorPopup = false

    var body: some View {
        content
            .popup(isPresented: $showGameCreatedPopup) {
                GameCreatedPopup(gameId: viewModel.gameId, isPresented: $showGameCreatedPopup)
            }
            .popup(isPresented: $showFindGamePopup) {
                FindGamePopup(isPresented: $showFindGamePopup, showGameNotFoundErrorPopup: $showGameNotFoundErrorPopup, showDefaultErrorPopup: $showDefaultErrorPopup)
                    .environmentObject(viewModel)
            }
            .popup(isPresented: $showDefaultErrorPopup) {
                ErrorPopup(isPresented: $showDefaultErrorPopup, title: "Error 🥲", description: "Something went wrong!", buttonText: "Ok")
            }
            .popup(isPresented: $showGameNotFoundErrorPopup) {
                ErrorPopup(isPresented: $showGameNotFoundErrorPopup, title: "Error 🥲", description: "Game with id \"\(viewModel.gameId)\" not found!", buttonText: "Ok")
            }
            .navigationBarBackButtonHidden()
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            facePalmImage
                .padding(.top, 118)
                .padding(.bottom, 14)
            createButton
            findMatchButton
            Spacer()
        }
        .padding(.horizontal, 64)
        .background(backgroundColor.ignoresSafeArea())
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
    
    private var facePalmImage: some View {
        Image("face-palm")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private var createButton: some View {
        LoadingButton() {
            do {
                try await viewModel.createGame()
                showGameCreatedPopup = true
            } catch {
                showDefaultErrorPopup = true
            }
        } label: {
            Text("Create match")
        }
        .buttonStyle(.primary(color: Color.fpLila))
    }
    
    private var findMatchButton: some View {
        Button {
            showFindGamePopup = true
        } label: {
            Text("Find match")
        }
        .buttonStyle(.primary(color: Color.fpBlue))
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(HomeViewModel())
    }
}
