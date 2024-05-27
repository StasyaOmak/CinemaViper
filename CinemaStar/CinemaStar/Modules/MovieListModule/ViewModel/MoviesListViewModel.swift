// MoviesListViewModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Интерфейс вью моделя для экрана списка фильмов
protocol MoviesListViewModelProtocol {
    func moveToMovieDetailScreen(id: Int)
    /// Получение фильмов с сети
    func fetchMovies(completion: @escaping VoidHandler)
    var state: ModelState<[Movie]> { get set }
}

/// Вью модель для экрана списка фильмов
final class MoviesListViewModel: MoviesListViewModelProtocol {
    // MARK: - Public Properties

    var state: ModelState<[Movie]>
    var movies: [Movie] = []

    // MARK: - Private Properties

    private var coordinator: BaseCoodinator?
    private var moviesRequest: APIRequest<MovieResource>?

    // MARK: - Initializers

    init(coordinator: BaseCoodinator) {
        self.coordinator = coordinator
        state = .loading
    }

    func fetchMovies(completion: @escaping VoidHandler) {
        let resource = MovieResource()
        let request = APIRequest(resource: resource)
        moviesRequest = request
        request.execute { [weak self] data in
            guard let fetchedMovies = data?.docs else { return }
            for movie in fetchedMovies {
                self?.movies.append(Movie(dto: movie))
            }
            guard let movies = self?.movies else { return }
            self?.state = .data(movies)
            print(movies)
            completion()
        }
    }

    func moveToMovieDetailScreen(id: Int) {
        guard let appCoordinator = coordinator as? AppCoordinator else { return }
        appCoordinator.goToMovieDetail(id: id)
    }
}
