// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель для ячейки фильма
struct Movie {
    let imageUrl: URL?
    let movieName: String?
    let rating: Double?
    let id: Int

    init(dto: MovieDTO) {
        imageUrl = URL(string: dto.poster.url)
        movieName = dto.name
        rating = Double(String(format: "%.1f", dto.rating?.kp ?? 0.0)) ?? 0
        id = dto.id
    }
}
