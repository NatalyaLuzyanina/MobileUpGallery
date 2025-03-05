//
//  GenericButtonStyle.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 29.10.2024.
//

import SwiftUI

struct GenericButtonStyle: ButtonStyle {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
    }

    let backgroundColorSet: GenericButtonColorsSet
    let foregroundColorSet: GenericButtonColorsSet
    let strokeColorSet: GenericButtonColorsSet

    @Binding private var isLoading: Bool
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = backgroundColorSet.getColor(
            isLoading: isLoading,
            isPressed: configuration.isPressed,
            isActive: isEnabled
        )

        let foregroundColor = foregroundColorSet.getColor(
            isLoading: isLoading,
            isPressed: configuration.isPressed,
            isActive: isEnabled
        )

        let strokeColor = strokeColorSet.getColor(
            isLoading: isLoading,
            isPressed: configuration.isPressed,
            isActive: isEnabled
        )

        configuration
            .label
            .lineLimit(nil)
            .foregroundColor(foregroundColor)
            .tint(foregroundColor)
            .font(.button)
            .background(backgroundColor)
            .cornerRadius(Constants.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(strokeColor, lineWidth: 0.5)
            )
    }

    static func get(
        type: GenericButtonStyleType,
        isLoading: Binding<Bool> = .constant(false)
    ) -> Self {
        switch type {
        case .primary:
            return getPrimaryGenericButtonStyle(isLoading: isLoading)
        case .text:
            return getTextGenericButtonStyle(isLoading: isLoading)
        }
    }

    private static func getPrimaryGenericButtonStyle(isLoading: Binding<Bool>) -> Self {
        let backgroundColorSet = GenericButtonColorsSet(
            active: R.color.buttonAccent.color,
            pressed: R.color.buttonAccent.color,
            disabled: R.color.buttonDisabled.color,
            loading: R.color.buttonAccent.color
        )

        let foregroundColorSet = GenericButtonColorsSet(
            active: R.color.textInverse.color,
            pressed: R.color.textSecondary.color,
            disabled: R.color.textSecondary.color,
            loading: R.color.textInverse.color
        )

        let strokeColorSet = GenericButtonColorsSet(
            active: .clear,
            pressed: .clear,
            disabled: .clear,
            loading: .clear
        )

        return GenericButtonStyle(
            backgroundColorSet: backgroundColorSet,
            foregroundColorSet: foregroundColorSet,
            strokeColorSet: strokeColorSet,
            isLoading: isLoading
        )
    }

    private static func getTextGenericButtonStyle(isLoading: Binding<Bool>) -> Self {
        let backgroundColorSet = GenericButtonColorsSet(
            active: .clear,
            pressed: .clear,
            disabled: .clear,
            loading: .clear
        )

        let foregroundColorSet = GenericButtonColorsSet(
            active: R.color.textPrimary.color,
            pressed: R.color.buttonDisabled.color,
            disabled: R.color.buttonDisabled.color,
            loading: R.color.textPrimary.color
        )

        let strokeColorSet = GenericButtonColorsSet(
            active: .clear,
            pressed: .clear,
            disabled: .clear,
            loading: .clear
        )

        return GenericButtonStyle(
            backgroundColorSet: backgroundColorSet,
            foregroundColorSet: foregroundColorSet,
            strokeColorSet: strokeColorSet,
            isLoading: isLoading
        )
    }
}
