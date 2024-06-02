// MoviesDetailsShimmerView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// Представление для мерцающего отображения  фильма.
struct MoviesDetailsShimmerView: View {
    let items = Array(1 ... 10)
    let horizontalPadding: CGFloat = 16
    let verticalPadding: CGFloat = 16
    let horizontalSpacing: CGFloat = 20
    let verticalSpacing: CGFloat = 10

    var body: some View {
        backgroundStackView(color: gradientColor) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: verticalSpacing) {
                    makeMoviePosterView(movie: items)
                    Spacer().frame(height: verticalSpacing)
                    watchButtonView
                    Spacer().frame(height: verticalSpacing)
                    makeCountryProductionView(movie: items)
                    Spacer().frame(height: verticalSpacing)
                    makeStarringView(movie: items)
                    Spacer().frame(height: verticalSpacing)
                    makeRecommendedMoviesView(movie: items)
                }
                .padding(horizontalPadding)
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private var watchButtonView: some View {
        ShimmerBoxView()
            .foregroundColor(.white)
            .frame(width: 358, height: 48)
            .background(.shimmer)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var gradientColor: LinearGradient {
        LinearGradient(colors: [.gradientTop, .gradientBottom], startPoint: .top, endPoint: .bottom)
    }

    private func makeMoviePosterView(movie: [Int]) -> some View {
        HStack(spacing: horizontalSpacing) {
            ShimmerBoxView()
                .frame(width: 170, height: 200)
                .cornerRadius(10)
            ShimmerBoxView()
                .foregroundColor(.white)
                .frame(width: 170, height: 70, alignment: .leading)
                .cornerRadius(10)
            Spacer()
        }
        .padding(.leading, horizontalPadding)
    }

    private func makeCountryProductionView(movie: [Int]) -> some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ShimmerBoxView()
                .frame(width: 355, height: 100)
                .cornerRadius(10)
                .padding(.leading, 4)
            ShimmerBoxView()
                .frame(width: 355, height: 20)
                .cornerRadius(10)
                .padding(.leading, 4)
        }
        .padding(.horizontal, horizontalPadding)
    }

    private func makeStarringView(movie: [Int]) -> some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ShimmerBoxView()
                .frame(width: 355, height: 20)
                .cornerRadius(10)
                .padding(.leading, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: horizontalSpacing) {
                    ForEach(items, id: \.self) { _ in
                        VStack(spacing: 2) {
                            ShimmerBoxView()
                                .frame(width: 50, height: 72)
                                .cornerRadius(8)
                            ShimmerBoxView()
                                .frame(width: 50, height: 14)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: verticalSpacing) {
                ShimmerBoxView()
                    .frame(width: 355, height: 15)
                    .cornerRadius(10)
                ShimmerBoxView()
                    .frame(width: 355, height: 15)
                    .cornerRadius(10)
            }
        }
        .padding(.leading, horizontalPadding)
        .foregroundColor(.white)
    }

    private func makeRecommendedMoviesView(movie: [Int]) -> some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ShimmerBoxView()
                .frame(width: 355, height: 15)
                .cornerRadius(10)
                .padding(.leading, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: horizontalSpacing) {
                    ForEach(items, id: \.self) { _ in
                        VStack(spacing: verticalSpacing) {
                            ShimmerBoxView()
                                .frame(width: 170, height: 220)
                                .cornerRadius(8)
                            ShimmerBoxView()
                                .frame(width: 170, height: 16)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding(.leading, horizontalPadding)
        .foregroundColor(.white)
    }
}

#Preview {
    MoviesDetailsShimmerView()
}
