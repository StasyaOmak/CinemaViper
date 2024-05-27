// AppCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Главный координатор
final class AppCoordinator: BaseCoodinator {
    // MARK: - Private Properties

    private var appBuilder: AppBuilder

    init(appBuilder: AppBuilder) {
        self.appBuilder = appBuilder
    }

    // MARK: - Private Methods

    override func start() {
        goToMoviesList()
    }

    func goToMoviesList() {
        let movieListModuleView = appBuilder.makeMovieListModule(coordinator: self)
        rootController = UINavigationController(rootViewController: movieListModuleView)
        guard let movieListView = rootController else { return }
        setAsRoot​(​_​: movieListView)
    }

    func goToMovieDetail(id: Int) {
        let movieDetailModuleView = appBuilder.setMovieDetailModule(
            id: id,
            coordinator: self
        )
        rootController?.pushViewController(movieDetailModuleView, animated: true)
    }

    func backToMoviesList() {
        rootController?.popViewController(animated: true)
    }
}
