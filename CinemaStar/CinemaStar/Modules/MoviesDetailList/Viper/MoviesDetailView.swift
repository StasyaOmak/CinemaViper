// MoviesDetailView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftData
import SwiftUI

// swiftlint:disable all

/// Вью экрана с детальным фильмом
struct MoviesDetailView: View {
    @Environment(\.modelContext) private var context: ModelContext
    @Query var movieDetail: [SwiftDataMovieDetail]
    @Environment(\.dismiss) var dismiss
    @State private var isfavoritesTapped = false
    @State private var isWatchButtonTapped = false
    @State private var isExpanded: Bool = false
    @StateObject var presenter: MoviesDetailPresenter

    var id: Int?

    var body: some View {
        backgroundStackView(color: gradientColor) {
            ScrollView(showsIndicators: false) {
                switch presenter.state {
                case .loading:
                    MoviesDetailsShimmerView()
                case let .data(movieDetail):
                    let storedMovie = self.movieDetail.first(where: { $0.movieID == id })
                    VStack {
                        makeMoviePosterView(movie: movieDetail, storedMovie: storedMovie)
                        Spacer().frame(height: 16)
                        watchButtonView
                        Spacer().frame(height: 16)
                        makeCountryProductionView(movie: movieDetail, storedMovie: storedMovie)
                        Spacer().frame(height: 16)
                        makeStarringView(movie: movieDetail, storedMovie: storedMovie)
                        Spacer().frame(height: 10)
                        makeRecommendedMoviesView(movie: movieDetail, storedMovie: storedMovie)
                    }
                case .error:
                    Text(S.Error.text)
                }
            }
            .toolbarBackground(gradientColor, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButtonView
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addToFavoritesButtonView
                }
            }
        }
        .onAppear {
            guard case .loading = presenter.state else { return }
            if movieDetail.first(where: { $0.movieID == self.id }) == nil {
                presenter.prepareMovieDetails(by: id ?? 0, context: context)
            } else {
                presenter.state = .data(MovieDetail())
                isfavoritesTapped = fetchIsFavoriteState(id: id ?? 0)
            }
        }
    }

    private var watchButtonView: some View {
        Button {
            isWatchButtonTapped.toggle()
        } label: {
            Text(S.DetailView.watchButton)
                .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .frame(width: 358, height: 48)
        .background(.gradientBottom)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert(isPresented: $isWatchButtonTapped, content: {
            Alert(
                title: Text(S.DetailView.Alert.message),
                message: Text(S.DetailView.Alert.text),
                dismissButton: .default(Text(S.DetailView.Alert.ok))
            )
        })
    }

    private var gradientColor: LinearGradient {
        LinearGradient(colors: [.gradientTop, .gradientBottom], startPoint: .top, endPoint: .bottom)
    }

    private var backButtonView: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: S.backbutton)
        }
        .foregroundColor(.white)
    }

    private var addToFavoritesButtonView: some View {
        Button {
            isfavoritesTapped.toggle()
            changeIsFavoriteState(isfavoritesTapped, id: id ?? 0)
        } label: {
            Image(
                systemName: isfavoritesTapped
                    ? S.heartButtonFilled
                    : S.heartButtonRegular
            )
        }
        .foregroundColor(.white)
    }

    init(presenter: MoviesDetailPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    private func makeMoviePosterView(movie: MovieDetail, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        HStack {
            if let image = storedMovie?.image.flatMap(UIImage.init(data:)) ?? movie.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 170, height: 200)
                    .cornerRadius(8)
            } else {
                ProgressView()
                    .frame(width: 170, height: 200)
            }
            VStack(alignment: .leading) {
                Text(storedMovie?.movieName ?? movie.movieName)
                    .font(.system(size: 18))
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(5)
                    .bold()
                Text("⭐️ \(String(format: "%.1f", storedMovie?.movieRating ?? movie.movieRating ?? 0.0))")
            }
            .foregroundColor(.white)
            .frame(width: 170, height: 70, alignment: .leading)
            Spacer()
        }
        .padding(.leading, 18)
    }

    private func makeCountryProductionView(movie: MovieDetail, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(storedMovie?.movieDescription ?? movie.description ?? "")
                    .font(.system(size: 14))
                    .lineLimit(isExpanded ? nil : 5)
                    .foregroundColor(.white)
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? S.chevronUP : S.chevronDOWN)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            Spacer()
            Text(
                "\(String(storedMovie?.year ?? movie.year ?? 0)) / \(storedMovie?.country ?? movie.country ?? "") / \(storedMovie?.contentType ?? movie.contentType ?? "")"
            )
            .font(.system(size: 14))
            .foregroundColor(.descriptionText)
        }
        .padding(.horizontal, 15)
    }

    private func makeStarringView(movie: MovieDetail, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        VStack(alignment: .leading) {
            Text(S.DetailView.castSection)
                .fontWeight(.medium)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if let storedMovie = storedMovie {
                        ForEach(storedMovie.actors, id: \.name) { actor in
                            VStack(spacing: 2) {
                                if let imageData = actor.image,
                                   let image = UIImage(data: imageData)
                                {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 50, height: 72)
                                } else {
                                    ProgressView()
                                        .frame(width: 50, height: 72)
                                }
                                Text(actor.name)
                                    .font(.system(size: 8))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60, height: 24)
                            }
                        }
                    } else {
                        ForEach(movie.actors, id: \.name) { actor in
                            VStack(spacing: 2) {
                                if let url = URL(string: actor.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 72)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 72)
                                    }
                                }
                                Text(actor.name)
                                    .font(.system(size: 8))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60, height: 24)
                            }
                        }
                    }
                }
            }
            Spacer()
                .frame(height: 14)
            VStack(alignment: .leading, spacing: 5) {
                Text(S.DetailView.language)
                Text(storedMovie?.language ?? movie.language ?? "")
                    .foregroundColor(.descriptionText)
            }
            .font(.system(size: 14))
        }
        .padding(.leading, 16)
        .foregroundColor(.white)
    }

    private func makeRecommendedMoviesView(movie: MovieDetail, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        VStack(alignment: .leading) {
            Text(S.DetailView.recommendedSection)
                .font(.system(size: 14))
                .fontWeight(.medium)
            Spacer()
                .frame(height: 12)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    let similarMovies = storedMovie?.similarMovies ?? movie.similarMovies
                    ForEach(similarMovies, id: \.id) { movie in
                        VStack(alignment: .leading, spacing: 8) {
                            if let url = URL(string: movie.imageUrl ?? "") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .frame(width: 170, height: 220)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 170, height: 220)
                                }
                            }
                            Text(movie.movieName ?? "")
                                .font(.system(size: 16))
                                .frame(width: 170, height: 18, alignment: .leading)
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
        }
        .padding(.leading, 16)
        .foregroundColor(.white)
    }

    private func changeIsFavoriteState(_ isFavorite: Bool, id: Int) {
        print(id)
        presenter.changeIsFavoriteState(isFavorite, id: id)
    }

    private func fetchIsFavoriteState(id: Int) -> Bool {
        presenter.fetchIsFavoriteState(id: id)
    }
}

#Preview {
    MoviesDetailView(presenter: MoviesDetailPresenter())
}

// swiftlint:enable all
