//
//  LoadingStateViewModifier.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 29.10.2024.
//

import SwiftUI

struct LoadingStateViewModifier<LoadingContent: View>: ViewModifier {
    var isLoading: Bool
    let loadingContentCreator: () -> LoadingContent

    func body(content: Content) -> some View {
        if isLoading {
            loadingContentCreator()
        } else {
            content
        }
    }
}
