//
//  VoteCardView.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 09.02.23.
//

import SwiftUI

struct VoteCardView: View {
    @EnvironmentObject private var viewModel: VoteViewModel
    @Binding var showVoteCardErrorPopup: Bool
    @Binding var showWaitingForOthersPopup: Bool
    
    let text: String
    let cardIndex: Int
    let cardId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            textView
            Spacer()
            buttonView
        }
        .padding(8)
        .background(Color.fpCream)
        .cornerRadius(8)
        .frame(
            width: .cardWidth,
            height: .cardWidth
        )
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
                try await viewModel.voteCard(cardId: cardId)
                showWaitingForOthersPopup = true
            } catch {
                showVoteCardErrorPopup = true
            }
        } label: {
            Text("Confirm")
        }
        .buttonStyle(.secondary())
        .opacity(isSelected ? 1 : 0)
    }
}

struct VoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        VoteCardView(showVoteCardErrorPopup: .constant(true), showWaitingForOthersPopup: .constant(false), text: "Meow", cardIndex: 0, cardId: 1)
            .environmentObject(VoteViewModel(gameId: "101", playerId: 1))
    }
}
