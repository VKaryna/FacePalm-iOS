//
//  ErrorPopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import SwiftUI

struct ErrorPopup: View {
    @Binding var isPresented: Bool
    var title: String
    var description: String
    var buttonText: String
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.bottom, 16)
            descriptionView
                .padding(.bottom, 24)
            okButton
        }
    }
    
    private var titleView: some View {
        Text(title)
            .font(.futuraMedium(size: 20))
    }
    
    private var descriptionView: some View {
        Text(description)
            .font(.futuraMedium(size: 18))
            .foregroundColor(.fpGray)
    }
    
    private var okButton: some View {
        Button {
            isPresented = false
        } label: {
            Text("\(buttonText)")
        }
        .buttonStyle(.secondary())
        .frame(width: 140)
    }
}

struct ErrorPopup_Previews: PreviewProvider {
    static var previews: some View {
        ErrorPopup(isPresented: .constant(true), title: "Title", description: "Description", buttonText: "Ok")
    }
}
