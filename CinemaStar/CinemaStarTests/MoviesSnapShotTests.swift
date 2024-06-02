// MoviesSnapShotTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import SnapshotTesting
import SwiftUI
import XCTest

final class MoviesSnapShotTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMoviewShimmerView() {
        let shimmerView = MoviesShimmerView()
        let view = UIHostingController(rootView: shimmerView)
//        isRecording = true
        assertSnapshot(matching: view, as: .image(size: CGSize(width: 390, height: 830)))
    }

    func testMoviesDetailShimmerView() {
        let shimmerDetailView = MoviesDetailsShimmerView()
        let view = UIHostingController(rootView: shimmerDetailView)
//        isRecording = true
        assertSnapshot(matching: view, as: .image(size: CGSize(width: 390, height: 830)))
    }
}
