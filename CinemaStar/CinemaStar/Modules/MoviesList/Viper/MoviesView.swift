// MoviesView.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import SwiftData
import SwiftUI

/// Вид экрана с фильмами.
struct MoviesView: View {
    @StateObject var presenter: MoviesPresenter
    @Query var swiftDataMovies: [SwiftDataMovie]
    @Environment(\.modelContext) var context

    var body: some View {
        NavigationStack {
            backgroundStackView(color: gradientColor) {
                VStack {
                    switch presenter.state {
                    case .loading:
                        MoviesShimmerView()
                    case let .data(fetchedMovies):
                        if fetchedMovies.isEmpty {
                            MoviesCollectionView(swiftDataMovies: swiftDataMovies)
                        } else {
                            MoviesCollectionView(movies: fetchedMovies)
                        }
                    case .error:
                        Text("Error")
                    }
                }
                .environmentObject(presenter)
                .background(
                    NavigationLink(
                        destination:
                        Assembly.buildMoviesDetailModule(id: presenter.selectedMovieID ?? 0),
                        isActive: Binding(
                            get: { presenter.selectedMovieID != nil },
                            set: { if !$0 { presenter.selectedMovieID = nil } }
                        )
                    ) {
                        EmptyView()
                    }
                )
                .onAppear {
                    guard case .loading = presenter.state else { return }
                    if swiftDataMovies.isEmpty {
                        presenter.prepareMovies(context: context)
                    } else {
                        presenter.state = .data([])
                    }
                }
            }
        }
    }

    private var gradientColor: LinearGradient {
        LinearGradient(colors: [.gradientTop, .gradientBottom], startPoint: .top, endPoint: .bottom)
    }

    init(presenter: MoviesPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
}

#Preview {
    MoviesView(presenter: MoviesPresenter())
}

/// Вью с фильмами
struct MoviesCollectionView: View {
    @EnvironmentObject var presenter: MoviesPresenter

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var movies: [Movie] = []
    var swiftDataMovies: [SwiftDataMovie] = []

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text(S.MoviesView.Title.firstPart)
                    +
                    Text(S.MoviesView.Title.secondPart)
                    .fontWeight(.heavy)
            }
            .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    if movies.isEmpty {
                        ForEach(swiftDataMovies, id: \.id) { movie in
                            VStack {
                                if let image = UIImage(data: movie.image ?? Data()) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 170, height: 220)
                                        .cornerRadius(8)
                                } else {
                                    ProgressView()
                                        .frame(width: 170, height: 220)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(String(movie.movieName))
                                    Text("⭐️ \(String(format: "%.1f", movie.rating))")
                                }
                                .frame(width: 170, height: 40, alignment: .leading)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                presenter.goToDetailScreen(with: movie.movieID)
                            }
                        }
                    } else {
                        ForEach(movies, id: \.id) { movie in
                            VStack {
                                if let image = movie.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 170, height: 220)
                                        .cornerRadius(8)
                                } else {
                                    ProgressView()
                                        .frame(width: 170, height: 220)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text(String(movie.movieName ?? ""))
                                    Text("⭐️ \(String(format: "%.1f", movie.rating ?? 0.0))")
                                }
                                .frame(width: 170, height: 40, alignment: .leading)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                presenter.goToDetailScreen(with: movie.id)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
