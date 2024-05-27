// AppBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Контейнер для проставления зависимостей и сборки модулей
final class AppBuilder {
    // MARK: - Public Methodes

    func makeMovieListModule(coordinator: BaseCoodinator) -> MoviesListViewController {
        let viewModel = MoviesListViewModel(coordinator: coordinator)
        let view = MoviesListViewController(moviesListViewModel: viewModel)
        return view
    }

    func setMovieDetailModule(
        id: Int,
        coordinator: BaseCoodinator
    ) -> MovieDetailViewController {
        let viewModel = MovieDetailViewModel(
            coordinator: coordinator,
            id: id
        )
        let view = MovieDetailViewController(
            id: id,
            movieDetailViewModel: viewModel
        )
        return view
    }
}
