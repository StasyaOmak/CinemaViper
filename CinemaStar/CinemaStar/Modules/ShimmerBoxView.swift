// ShimmerBoxView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// Представление, представляющее мерцающий блок.
struct ShimmerBoxView: View {
    @State private var startPoint: UnitPoint = .init(x: -2, y: -1.5)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.5)

    private var gradientColors = [
        Color(uiColor: UIColor.systemGray),
        Color(uiColor: UIColor.systemGray5),
    ]

    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                startPoint = .init(x: 2, y: 2)
                endPoint = .init(x: 2.2, y: 2.2)
            }
        }
    }
}

#Preview {
    ShimmerBoxView()
}
