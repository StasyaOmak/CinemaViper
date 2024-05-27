// PrepareForAutolayout.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Отключает translatesAutoresizingMaskIntoConstraints
public func prepareForAutoLayout<T: UIView>(_ view: T) -> T {
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
