// Strings+Generated.swift
// Copyright © RoadMap. All rights reserved.

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum S {
    /// chevron.backward
    static let backbutton = S.tr("Localizable", "backbutton", fallback: "chevron.backward")
    /// chevron.down
    static let chevronDOWN = S.tr("Localizable", "chevronDOWN", fallback: "chevron.down")
    /// chevron.up
    static let chevronUP = S.tr("Localizable", "chevronUP", fallback: "chevron.up")
    /// heart.fill
    static let heartButtonFilled = S.tr("Localizable", "heartButtonFilled", fallback: "heart.fill")
    /// heart
    static let heartButtonRegular = S.tr("Localizable", "heartButtonRegular", fallback: "heart")
    /// TokenKey
    static let keychainToken = S.tr("Localizable", "KeychainToken", fallback: "TokenKey")
    /// YTWNR4R-V9MM33F-MZDXDN5-MZKAD3D
    static let token1 = S.tr("Localizable", "token1", fallback: "YTWNR4R-V9MM33F-MZDXDN5-MZKAD3D")
    /// YK5JXSC-Q4BMZ92-NXXTRQ0-HJD6DMC
    static let token2 = S.tr("Localizable", "token2", fallback: "YK5JXSC-Q4BMZ92-NXXTRQ0-HJD6DMC")
    enum DetailView {
        /// Актеры и съемочная группа
        static let castSection = S.tr("Localizable", "DetailView.castSection", fallback: "Актеры и съемочная группа")
        /// Язык
        static let language = S.tr("Localizable", "DetailView.language", fallback: "Язык")
        /// Смотрите также
        static let recommendedSection = S.tr("Localizable", "DetailView.recommendedSection", fallback: "Смотрите также")
        /// Смотреть
        static let watchButton = S.tr("Localizable", "DetailView.watchButton", fallback: "Смотреть")
        enum Alert {
            /// Функционал в разработке
            static let message = S.tr("Localizable", "DetailView.alert.message", fallback: "Функционал в разработке")
            /// Ок
            static let ok = S.tr("Localizable", "DetailView.alert.ok", fallback: "Ок")
            /// Ошибка
            static let text = S.tr("Localizable", "DetailView.alert.text", fallback: "Ошибка")
        }
    }

    enum Error {
        /// error
        static let text = S.tr("Localizable", "Error.text", fallback: "error")
    }

    enum MoviesView {
        enum Title {
            /// Localizable.strings
            ///   CinemaStar
            ///
            ///  Created by Anastasiya Omak on 02/06/2024.
            static let firstPart = S.tr(
                "Localizable",
                "MoviesView.title.firstPart",
                fallback: "Смотри исторические\nфильмы на "
            )
            /// CINEMA STAR
            static let secondPart = S.tr("Localizable", "MoviesView.title.secondPart", fallback: "CINEMA STAR")
        }
    }

    enum NetworkService {
        /// X-API-KEY
        static let httpHeader = S.tr("Localizable", "NetworkService.HTTPHeader", fallback: "X-API-KEY")
        /// https://api.kinopoisk.dev/v1.4/movie/
        static let movieDetailURL = S.tr(
            "Localizable",
            "NetworkService.movieDetailURL",
            fallback: "https://api.kinopoisk.dev/v1.4/movie/"
        )
        /// https://api.kinopoisk.dev/v1.4/movie/search?query=история
        static let moviesURL = S.tr(
            "Localizable",
            "NetworkService.moviesURL",
            fallback: "https://api.kinopoisk.dev/v1.4/movie/search?query=история"
        )
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension S {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
