// MoviesShimmerView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// Представление для мерцающего отображения списка фильмов.
struct MoviesShimmerView: View {
    let items = Array(1 ... 6)

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        backgroundStackView(color: gradientColor) {
            VStack(spacing: 14) {
                Spacer().frame(height: 140)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Смотри исторические\nфильмы на ")
                        .fontWeight(.regular) +
                        Text("CINEMA STAR")
                        .fontWeight(.heavy)
                }
                .frame(maxWidth: 300)
                .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { _ in
                        VStack {
                            ShimmerBoxView()
                                .frame(width: 170, height: 220)
                                .cornerRadius(8)
                            Spacer()
                            VStack(alignment: .leading, spacing: 2) {
                                ShimmerBoxView()
                                ShimmerBoxView()
                            }
                            .frame(width: 140, height: 20)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
        }
    }

    private var gradientColor: LinearGradient {
        LinearGradient(colors: [.gradientTop, .gradientBottom], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    MoviesShimmerView()
}
