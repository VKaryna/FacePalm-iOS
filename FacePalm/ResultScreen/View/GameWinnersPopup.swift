//
//  GameWinnersPopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.03.23.
//

import SwiftUI

struct GameWinnersPopup: View {
    @Binding var isPresented: Bool
    let winners: [Player]
        
    var body: some View {
        VStack(spacing: 16) {
            titleView
            descriptionView
            okButton
        }
        .padding()
    }
    
    private var titleView: some View {
        Text("Game \(winners.count > 1 ? "winners" : "winner") 👑")
            .font(.futuraMedium(size: 20))
    }
    
    private var descriptionView: some View {
        Text("\(winners.map { winner in winner.name }.joined(separator: ", "))")
                .font(.futuraMedium(size: 18))
                .foregroundColor(.fpGray)
    }
    
    private var okButton: some View {
        Button {
            isPresented = false
        } label: {
            Text("Ok")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
}

struct GameWinnersPopup_Previews: PreviewProvider {
    static var previews: some View {
        WinnersPopup(isPresented: .constant(true), winners: [Player(id: 1, name: "Karyna", isReady: true, cards: [])])
    }
}
