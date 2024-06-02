// CinemaStarApp.swift
// Copyright © RoadMap. All rights reserved.

import SwiftData
import SwiftUI

@main
struct CinemaStarApp: App {
    var body: some Scene {
        WindowGroup {
            Assembly.buildMoviesModule()
                .modelContainer(for: [SwiftDataMovie.self, SwiftDataMovieDetail.self])
        }
    }

    init() {
        KeychainService.shared.token = S.token1
    }
}
