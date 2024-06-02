// MoviesDetailInteractorTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import Combine
import SwiftData
import XCTest

// Mock Presenter
class MockMoviesDetailPresenter: MoviesDetailPresenterProtocol {
    func changeIsFavoriteState(_ isFavorite: Bool, id: Int) {}

    func fetchIsFavoriteState(id: Int) -> Bool {
        true
    }

    func prepareMovieDetails(by id: Int, context: ModelContext) {}

    var didFetchMovieDetail = false
    var fetchedMovieDetail: MovieDetail?

    func didFetchMovieDetail(_ movieDetail: MovieDetail) {
        didFetchMovieDetail = true
        fetchedMovieDetail = movieDetail
    }
}

final class MoviesDetailInteractorTests: XCTestCase {
    var interactor: MoviesDetailInteractor!
    var mockNetworkService: MockNetworkService!
    var mockPresenter: MockMoviesDetailPresenter!

    override func setUp() {
        super.setUp()
        interactor = MoviesDetailInteractor()
        mockNetworkService = MockNetworkService()
        mockPresenter = MockMoviesDetailPresenter()
        interactor.networkService = mockNetworkService
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testFetchMovieDetailsSuccess() {
        let movieDTO = MovieDTO(
            name: "Сдохни или умри",
            id: 99999,
            poster: PosterDTO(
                url: "https://3fc4ed44-3fbc-419a-97a1-a29742511391.selcdn.net/coub_storage/coub/simple/cw_timeline_pic/7b120ae7fab/5aada574eedf6e7e26c8d/1576499871_image.jpg"
            ),
            rating: RatingDTO(kp: 10),
            description: "Horror in the city",
            year: 2024,
            countries: nil,
            type: nil,
            persons: [
                PersonDTO(name: "Anastasiya Omak", photo: nil)
            ],
            spokenLanguages: nil,
            similarMovies: nil
        )
        let movieImage = UIImage()
        mockNetworkService.fetchMovieResult = .success(movieDTO)
        mockNetworkService.fetchImageResult = .success(movieImage)

        let expectation = self.expectation(description: "fetchMovieDetails")

        interactor.fetchMovieDetails(by: 12345)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertTrue(mockPresenter.didFetchMovieDetail)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.year, 2012)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.movieName, "Сдохни или умри")
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.image, movieImage)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.movieRating, 10)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.actors.first?.name, "Anastasiya Omak")
    }

    func testFetchMovieDetailsFailure() {
        let error = NSError(domain: "testError", code: 1, userInfo: nil)
        mockNetworkService.fetchMovieResult = .failure(error)

        let expectation = self.expectation(description: "fetchMovieDetails")

        interactor.fetchMovieDetails(by: 12345)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertFalse(mockPresenter.didFetchMovieDetail)
    }
}
