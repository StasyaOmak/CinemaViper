// PersonDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// DTO-структура, представляющая информацию об актере
struct PersonDTO: Codable {
    /// Имя актера
    let name: String?
    /// Ссылка на изображение актера
    let photo: String?
}
