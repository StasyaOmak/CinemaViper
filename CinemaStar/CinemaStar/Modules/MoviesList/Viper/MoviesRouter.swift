// MoviesRouter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для взаимодействия с роутером экрана с фильмами.
protocol MoviesRouterProtocol {
    /// Метод для навигации к экрану детальной информации о фильме.
    ///
    /// - Parameters:
    ///   - presenter: Презентер экрана с фильмами.
    ///   - id: Идентификатор выбранного фильма.
    func navigateToDetailScreen(with presenter: MoviesPresenter, id: Int)
}

/// Роутер экрана с фильмами
class MoviesRouter: MoviesRouterProtocol {
    func navigateToDetailScreen(with presenter: MoviesPresenter, id: Int) {
        presenter.selectedMovieID = id
    }
}
