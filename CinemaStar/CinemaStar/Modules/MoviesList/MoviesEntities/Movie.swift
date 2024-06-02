// Movie.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Модель фильма.
struct Movie {
    /// URL изображения фильма.
    let imageUrl: String?

    /// Название фильма.
    let movieName: String?

    /// Рейтинг фильма.
    let rating: Double?

    /// Идентификатор фильма.
    let id: Int

    /// Изображение фильма.
    var image: UIImage?

    /// Инициализатор модели фильма на основе данных из объекта MovieDTO.
    ///
    /// - Parameter dto: Объект MovieDTO, содержащий данные фильма.
    init(dto: MovieDTO) {
        imageUrl = dto.poster.url
        movieName = dto.name
        rating = dto.rating?.kp
        id = dto.id
    }
}
