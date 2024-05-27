// ModelState.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Состояние  данных на экране фильмов
public enum ModelState<Model> {
    /// Данные загружаются
    case loading
    /// Есть данные
    case data(_ data: Model)
    /// Нет данных
    case noData
    /// Ошибка
    case error
}
