// MoviesInteractorTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import Combine
import SwiftData
import XCTest

// Mock NetworkService
class MockNetworkService: NetworkServiceProtocol {
    func fetchMovie(by id: Int) -> AnyPublisher<CinemaStar.MovieDTO, any Error> {
        fetchMovieResult.publisher.eraseToAnyPublisher()
    }

    func fetchMovies() -> AnyPublisher<MoviesDTO, any Error> {
        fetchMoviesResult.publisher.eraseToAnyPublisher()
    }

    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, any Error> {
        fetchImageResult.publisher.eraseToAnyPublisher()
    }

    var fetchMovieResult: Result<MovieDTO, Error>!
    var fetchMoviesResult: Result<MoviesDTO, Error>!
    var fetchImageResult: Result<UIImage?, Error>!
}

// Mock Presenter
class MockMoviesPresenter: MoviesPresenterProtocol {
    func prepareMovies(context: ModelContext) {}
    func goToDetailScreen(with id: Int) {}

    var didFetchMovies = false
    var fetchedMovies: [Movie]?

    func didFetchMovies(_ movies: [Movie]) {
        didFetchMovies = true
        fetchedMovies = movies
    }
}

final class MoviesInteractorTests: XCTestCase {
    var interactor: MoviesInteractor!
    var mockNetworkService: MockNetworkService!
    var mockPresenter: MockMoviesPresenter!

    override func setUp() {
        super.setUp()
        interactor = MoviesInteractor()
        mockNetworkService = MockNetworkService()
        mockPresenter = MockMoviesPresenter()
        interactor.networkService = mockNetworkService
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testFetchMoviesSuccess() {
        let moviesDTO = MoviesDTO(docs: [
            MovieDTO(
                name: "Сдохни или умри",

                id: 99999,
                poster: PosterDTO(url: "сдохниилиумри"),
                rating: RatingDTO(kp: 10),

                description: "Horror in the city",
                year: 2024,
                countries: nil,
                type: nil,
                persons: nil,
                spokenLanguages: nil,
                similarMovies: nil
            ),
            MovieDTO(
                name: "Трутиту",

                id: 66666,
                poster: PosterDTO(url: "трутиту"),
                rating: RatingDTO(kp: 8),
                description: "Трутиту",
                year: 2024,
                countries: nil,
                type: nil,
                persons: nil,
                spokenLanguages: nil,
                similarMovies: nil
            )
        ])
        let image = UIImage()
        mockNetworkService.fetchMoviesResult = .success(moviesDTO)
        mockNetworkService.fetchImageResult = .success(image)

        let expectation = self.expectation(description: "fetchMovies")

        interactor.fetchMovies()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertTrue(mockPresenter.didFetchMovies)
        XCTAssertEqual(mockPresenter.fetchedMovies?.count, 2)
        XCTAssertEqual(mockPresenter.fetchedMovies?.first?.movieName, "Сдохни или умри")
        XCTAssertEqual(mockPresenter.fetchedMovies?.last?.movieName, "Трутиту")
        XCTAssertEqual(mockPresenter.fetchedMovies?.last?.image, image)
    }

    func testFetchMoviesFailure() {
        let error = NSError(domain: "testError", code: 1, userInfo: nil)
        mockNetworkService.fetchMoviesResult = .failure(error)

        let expectation = self.expectation(description: "fetchMovies")

        interactor.fetchMovies()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertFalse(mockPresenter.didFetchMovies)
    }
}
