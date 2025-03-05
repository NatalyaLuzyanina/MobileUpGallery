//
//  GenericButtonContentView.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 29.10.2024.
//

import SwiftUI

struct GenericButtonContentView: View {
    let title: String

    @Binding var isLoading: Bool

    var body: some View {
        Text(title)
            .loadingState(isLoading: isLoading) { ProgressView() }
    }

    init(title: String, isLoading: Binding<Bool> = .constant(false)) {
        self.title = title
        self._isLoading = isLoading
    }
}
