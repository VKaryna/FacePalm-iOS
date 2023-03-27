//
//  WaitingMorePlayers.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 03.03.23.
//

import SwiftUI

struct WaitingMorePlayersPopup: View {
    @Binding var isPresented: Bool
    let playersCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            titleView
            descriptionView
            okButton
        }
        .padding()
    }
    
    private var titleView: some View {
        Text("Waiting for other players to join 💤")
            .font(.futuraMedium(size: 20))
    }
    
    private var okButton: some View {
        Button() {
            isPresented = false
        } label: {
            Text("Ok")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        let shouldJoinGame = 3 - playersCount
        Text("At least \(shouldJoinGame) more \(shouldJoinGame == 1 ? "player" : "players") should join the game")
            .font(.futuraMedium(size: 18))
            .foregroundColor(.fpGray)
    }
}

struct WaitingMorePlayersPopup_Previews: PreviewProvider {
    static var previews: some View {
        WaitingMorePlayersPopup(isPresented: .constant(true), playersCount: 2);
    }
}
