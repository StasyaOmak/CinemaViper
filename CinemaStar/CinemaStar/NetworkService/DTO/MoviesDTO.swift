// MoviesDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// MARK: - Movies

/// Структура, представляющая объект данных о фильмах
struct MoviesDTO: Codable {
    /// Массив объектов MovieDTO, содержащих информацию о фильмах
    let docs: [MovieDTO]
}
