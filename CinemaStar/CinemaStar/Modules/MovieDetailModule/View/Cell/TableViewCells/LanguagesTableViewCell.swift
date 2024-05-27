// LanguagesTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Язык фильма
final class LanguagesTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "LanguagesTableViewCell"

        enum Texts {
            static let titleLabel = "Язык"
        }

        enum Insets {
            static let verticalInset: CGFloat = 5
        }
    }

    // MARK: - Visual Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.text = Constants.Texts.titleLabel
        label.textColor = .white
        return label
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .languageText
        return label
    }()

    // MARK: - Initalizers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupContetnview()
    }

    // MARK: - Public Methods

    func configureCell(info: MovieDetail) {
        print("info \(info)")
        languageLabel.text = info.language
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubviews([
            titleLabel,
            languageLabel
        ])
    }

    private func setupConstraints() {
        configureTitleLabelConstraints()
        configureLanguageLabelConstraints()
    }

    private func setupContetnview() {
        contentView.backgroundColor = .yellow
    }
}

// MARK: - Extensions

/// Pасширение для устоновки размеров и расположения элементов
extension LanguagesTableViewCell {
    private func configureTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.Insets.verticalInset
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            titleLabel.heightAnchor.constraint(
                equalToConstant: 20
            ),
        ])
    }

    private func configureLanguageLabelConstraints() {
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.Insets.verticalInset
            ),
            languageLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            languageLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            languageLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.Insets.verticalInset
            )
        ])
    }
}
