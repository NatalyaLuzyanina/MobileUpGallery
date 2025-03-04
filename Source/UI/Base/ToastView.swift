//
//  ToastView.swift
//  ai-drawing
//
//  Created by Maria Nesterova on 16.09.2024.
//

import SwiftUI

struct ToastView: View {
    @Binding private var isPresented: Bool

    private let message: String

    init(isPresented: Binding<Bool>, message: String) {
        _isPresented = isPresented
        self.message = message
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(alignment: .center) {
                HStack(spacing: 8) {
                    Text(message)
                        .font(.titleMedium)
                        .foregroundColor(R.color.textInverse.color)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(R.color.buttonAccent.color)
                .cornerRadius(32)
                .padding(.bottom, 8)
            }
        }
        .opacity(isPresented ? 1 : 0)
    }
}

struct InformationToastViewPreview: PreviewProvider {
    static var previews: some View {
        ToastView(
            isPresented: .constant(true),
            message: "Done! Will be updated soon"
        )
    }
}
