// ViewState.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Состояния данных в представлении.
public enum ViewState<Model> {
    /// Данные загружаются.
    case loading
    /// Доступны данные.
    case data(_ data: Model)
    /// Произошла ошибка.
    case error
}
