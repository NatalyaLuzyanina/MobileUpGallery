//
//  GenericButton.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 29.10.2024.
//

import SwiftUI

struct GenericButton: View {
    let styleType: GenericButtonStyleType
    let title: String
    let tapHandler: (() -> Void)

    var isLoading: Binding<Bool>

    var body: some View {
        Button(action: tapHandler) {
            GenericButtonContentView(title: title, isLoading: isLoading)
                .frame(height: styleType == .text ? nil : 52)
                .frame(
                    maxWidth: styleType == .text ? nil : .infinity,
                    alignment: styleType == .text ? .leading : .center
                )
                .padding(.horizontal, 16)
        }
        .buttonStyle(GenericButtonStyle.get(type: styleType, isLoading: isLoading))
    }

    init(
        styleType: GenericButtonStyleType,
        title: String,
        tapHandler: @escaping (() -> Void),
        isLoading: Binding<Bool> = .constant(false)
    ) {
        self.styleType = styleType
        self.title = title
        self.tapHandler = tapHandler
        self.isLoading = isLoading
    }
}
