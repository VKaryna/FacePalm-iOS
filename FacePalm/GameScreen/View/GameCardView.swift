//
//  GameCardView.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 06.02.23.
//

import SwiftUI

struct GameCardView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Binding var showChooseCardErrorPopup: Bool
    @Binding var showWaitingForOthersPopup: Bool
    
    let text: String
    let cardIndex: Int
    let cardId: Int
    var size: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                textView
                buttonView.opacity(0)
            }
            buttonView
        }
        .padding(8)
        .background(Color.fpCream)
        .cornerRadius(8)
        .frame(
          width: Settings.thumbnailSize(size: size).width,
          height: Settings.thumbnailSize(size: size).height)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 3)
                .foregroundColor(isSelected ? .green : .clear)
                .padding(1.5)
        )
        .onTapGesture {
            viewModel.selectedCardIndex = cardIndex
        }
    }
    
    private var isSelected: Bool {
        cardIndex == viewModel.selectedCardIndex
    }
    
    private var textView: some View {
        Text(text)
            .font(.futuraMedium(size: 18))
            .foregroundColor(.black)
    }
    
    private var buttonView: some View {
        LoadingButton() {
            do {
                try await viewModel.chooseCard(cardId: cardId)
                showWaitingForOthersPopup = true
            } catch {
                showChooseCardErrorPopup = true
            }
        } label: {
            Text("Confirm")
        }
        .buttonStyle(.secondary())
        .opacity(isSelected ? 1 : 0)
    }
}

struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        return GameCardView(showChooseCardErrorPopup: .constant(true), showWaitingForOthersPopup: .constant(false), text: "Meow", cardIndex: 0, cardId: 1)
            .environmentObject(GameViewModel(gameId: "23", playerId: 1))
    }
}
