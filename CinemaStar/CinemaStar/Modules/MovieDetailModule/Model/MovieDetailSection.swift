// MovieDetailSection.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Типы ячеек для детального экрана
enum MovieDetailSection: CaseIterable {
    /// Кейс для секции с постером и названием фильма
    case info
    /// Кейс для секции с описанием фильма
    case description
    /// Кейс для секции с актерами
    case actors
    /// Кейс для секции с рекомендованными фильиами
    case similar
}
