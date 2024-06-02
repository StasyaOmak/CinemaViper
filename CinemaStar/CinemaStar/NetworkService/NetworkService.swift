// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import UIKit

/// Протокол для взаимодействия с сетевым сервисом
protocol NetworkServiceProtocol {
    /// Метод для получения списка фильмов
    ///
    /// - Returns: Публишер, который выдаёт объект MoviesDTO или ошибку
    func fetchMovies() -> AnyPublisher<MoviesDTO, Error>

    /// Метод для получения изображения по URL
    ///
    /// - Parameter url: URL изображения
    /// - Returns: Публишер, который выдаёт объект UIImage или ошибку
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Error>

    /// Метод для получения информации о фильме по его идентификатору
    ///
    /// - Parameter id: Идентификатор фильма
    /// - Returns: Публишер, который выдаёт объект MovieDTO или ошибку
    func fetchMovie(by id: Int) -> AnyPublisher<MovieDTO, Error>
}

/// Сетевой сервис для работы с API
class NetworkService: NetworkServiceProtocol {
    private func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(KeychainService.shared.token, forHTTPHeaderField: S.NetworkService.httpHeader)
        return request
    }

    private func performRequest<T: Decodable>(
        with request: URLRequest,
        decodingType: T.Type
    ) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: decodingType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchMovies() -> AnyPublisher<MoviesDTO, Error> {
        guard let url = URL(string: S.NetworkService.moviesURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        let request = makeRequest(for: url)
        return performRequest(with: request, decodingType: MoviesDTO.self)
    }

    func fetchMovie(by id: Int) -> AnyPublisher<MovieDTO, Error> {
        guard let url = URL(string: "\(S.NetworkService.movieDetailURL)\(id)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        let request = makeRequest(for: url)
        return performRequest(with: request, decodingType: MovieDTO.self)
    }

    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
