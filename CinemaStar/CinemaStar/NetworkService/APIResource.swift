// APIResource.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол, определяющий ресурс для запросов к API
protocol APIResource {
    /// Ассоциированный тип модели данных, который будет возвращаться из запроса
    associatedtype ModelType: Decodable
    /// Путь к ресурсу на сервере API
    var path: String { get }
}

/// Ресурс для поиска всех фильмов
struct MovieResource: APIResource {
    typealias ModelType = MoviesDTO

    var path = "/search"
}

/// Ресурс для поиска конкретного фильма
struct MovieDetailResource: APIResource {
    typealias ModelType = MovieDTO

    var id: Int?

    var path: String {
        guard let id = id else {
            return ""
        }
        return "/\(id)"
    }
}

// MARK: - APIResource

extension APIResource {
    var url: URL? {
        var components = URLComponents(string: "https://api.kinopoisk.dev/v1.4/movie") ?? URLComponents()
        components.path += path
        if path == "/search" {
            components.queryItems = [URLQueryItem(name: "query", value: "История")]
        }
        return components.url
    }
}
