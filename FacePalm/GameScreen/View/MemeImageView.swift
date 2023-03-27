//
//  MemeImageView.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 06.02.23.
//

import SwiftUI

struct MemeImageView: View {
    @State private var isRoundLabelVisible = false
    
    let imageName: String?
    let roundNumber: Int?
    
    var body: some View {
        ZStack(alignment: .top) {
            memeImageView
            if isRoundLabelVisible, let currentRound = roundNumber {
                roundView(currentRound)
            }
        }
        .aspectRatio(contentMode: .fit)
        .cornerRadius(16)
        .onAppear {
            isRoundLabelVisible = true
        }
    }
    
    private var memeImageView: some View {
        Image(imageName ?? "image1")
            .resizable()
    }
    
    private func roundView(_ round: Int) -> some View {
        Text("Round \(round)")
            .frame(width: 128)
            .font(.futuraMedium(size: 24))
            .foregroundColor(.black)
            .background(Color.fpCream)
            .cornerRadius(8)
            .padding(8)
            .transition(.move(edge: .top))
            .zIndex(1)
            .task {
                try? await Task.sleep(for: .seconds(3))
                withAnimation {
                    isRoundLabelVisible = false
                }
            }
    }
}
