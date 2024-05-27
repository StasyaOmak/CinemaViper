// MovieDetail.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Детали фильма
struct MovieDetail {
    let movieName: String
    let movieRating: String?
    let imageURL: URL?
    let id: Int
    let description: String?
    let year: Int?
    let country: String?
    let contentType: String?
    var actors: [MovieActor]? = []
    let language: String?
    var similarMovies: [Movie] = []

    init(dto: MovieDTO) {
        movieName = dto.name
        movieRating = String(format: "%.1f", dto.rating?.kp ?? 0)
        imageURL = URL(string: dto.poster.url)
        id = dto.id
        description = dto.description
        year = dto.year
        country = dto.countries?.first?.name ?? ""
        contentType = {
            if dto.type == "movie" {
                return "Фильм"
            } else {
                return "Сериал"
            }
        }()
        language = dto.spokenLanguages?.first?.name
        actors = dto.persons?.map(MovieActor.init)
        guard let movies = dto.similarMovies else { return }
        similarMovies = movies.map(Movie.init)
    }
}

/// Рекомендованные фильмы
struct SimilarMovie {
    let similarMovieImageName: String?
    let similarMovieName: String?

    init(dto: MovieDTO) {
        similarMovieImageName = dto.poster.url
        similarMovieName = dto.name
    }
}

/// Актёры
struct MovieActor {
    /// Имя актера
    let name: String?
    /// Ссылка на изображение актера
    let imageURL: String?

    init(dto: PersonDTO) {
        name = dto.name
        imageURL = dto.photo
    }
}
