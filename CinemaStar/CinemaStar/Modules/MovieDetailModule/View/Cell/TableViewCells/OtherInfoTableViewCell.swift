// OtherInfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Другая информация
final class OtherInfoTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "OtherInfoTableViewCell"

        enum Texts {
            static let titleLabel = "Язык"
        }

        enum Insets {
            static let verticalInset: CGFloat = 10
        }
    }

    // MARK: - Visual Components

    private let otherInfoLabel: UILabel = {
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
        let year = info.year ?? 9999
        let country = info.country ?? "country"
        let type = info.contentType ?? "Сериал"
        otherInfoLabel.text = "\(year)/\(country)/\(type)"
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubviews([
            otherInfoLabel
        ])
    }

    private func setupConstraints() {
        configureOtherInfoLabelConstraints()
    }

    private func setupContetnview() {
        contentView.backgroundColor = .yellow
    }
}

// MARK: - Extensions

/// Pасширение для устоновки размеров и расположения элементов
extension OtherInfoTableViewCell {
    private func configureOtherInfoLabelConstraints() {
        NSLayoutConstraint.activate([
            otherInfoLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.Insets.verticalInset
            ),
            otherInfoLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            otherInfoLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
        ])
    }
}
