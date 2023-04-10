//
//  GameCreatedPopUp.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 22.01.23.
//

import SwiftUI

struct GameCreatedPopup: View {
    @EnvironmentObject private var navigation: AppNavigation
    let gameId: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
           titleView
                .padding(.bottom, 16)
            HStack {
                descriptionView
                shareButton
            }
            .padding(.bottom, 24)
            continueButton
        }
    }
    
    private var descriptionView: some View {
        Text("Your game id is \(gameId)")
            .font(.futuraMedium(size: 18))
            .foregroundColor(.fpGray)
    }
    
    private var titleView: some View {
        Text("Game is created 🍾")
            .font(.futuraMedium(size: 20))
    }
    
    private var shareButton: some View {
        ShareLink(item: ShareContent(gameID: gameId).content) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.black)
        }
    }
    
    private var continueButton: some View {
        Button {
            isPresented = false
            navigation.path.append(Screen.players(gameId: gameId))
        } label: {
            Text("Continue")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
}

struct GameCreatedPopup_Previews: PreviewProvider {
    static var previews: some View {
        GameCreatedPopup(gameId: "101", isPresented: .constant(true))
    }
}
