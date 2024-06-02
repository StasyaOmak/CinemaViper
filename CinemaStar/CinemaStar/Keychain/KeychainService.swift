// KeychainService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import KeychainSwift

/// Кейчен для работы с API ключом.
class KeychainService {
    static let shared = KeychainService()

    var token: String? {
        get { keychain.get(S.keychainToken) }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: S.keychainToken)
            } else {
                keychain.delete(S.keychainToken)
            }
        }
    }

    private let keychain = KeychainSwift()

    private init() {}
}
