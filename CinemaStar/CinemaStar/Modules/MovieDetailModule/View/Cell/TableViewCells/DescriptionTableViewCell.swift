// DescriptionTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Описание фильма
final class DescriptionTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum ExpandButtonState: String {
        case expanded = "chevron.up"
        case collapsed = "chevron.down"
    }

    enum Constants {
        static let identifier = "DescriptionTableViewCell"

        enum Insets {
            static let textViewHeightHide: CGFloat = 200
            static let textViewHeightUnhide: CGFloat = 308
            static let topInset: CGFloat = 16
            static let iconSize: CGFloat = 24
            static let smallInset: CGFloat = 6
        }
    }

    // MARK: - Visual Components

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 5
        label.setContentCompressionResistancePriority(
            .required,
            for: .vertical
        )
        label.setContentHuggingPriority(
            .required,
            for: .vertical
        )
        return label
    }()

    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = true
        button.setImage(
            UIImage(systemName: "chevron.down"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(didTapExpandButton(_:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Private properties

    private var expandButtonState: ExpandButtonState = .collapsed
    private var isExpanded = false
    var onExpandButtonTap: VoidHandler?

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
        descriptionLabel.text = info.description
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubviews([
            descriptionLabel,
            expandButton
        ])
    }

    private func setupConstraints() {
        configureDescriptionLabelConstraints()
        configureExpandButtonConstraints()
    }

    private func setupContetnview() {
        contentView.backgroundColor = .yellow
    }

    private func toggleExpandButton(to state: ExpandButtonState) {
        switch state {
        case .expanded:
            expandButton.setImage(
                UIImage(systemName: "chevron.down"),
                for: .normal
            )
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
            onExpandButtonTap?()
        case .collapsed:
            expandButton.setImage(
                UIImage(systemName: "chevron.up"),
                for: .normal
            )
            descriptionLabel.numberOfLines = 5
            onExpandButtonTap?()
        }
    }

    @objc private func didTapExpandButton(_ sender: UIButton) {
        isExpanded.toggle()
        let state: ExpandButtonState = isExpanded
            ? .expanded
            : .collapsed
        toggleExpandButton(to: state)
    }
}

/// Pасширение для устоновки размеров и расположения элементов
extension DescriptionTableViewCell {
    private func configureDescriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.Insets.topInset
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }

    private func configureExpandButtonConstraints() {
        NSLayoutConstraint.activate([
            expandButton.bottomAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor
            ),
            expandButton.trailingAnchor.constraint(
                equalTo: descriptionLabel.trailingAnchor
            ),
            expandButton.heightAnchor.constraint(
                equalToConstant: Constants.Insets.iconSize
            ),
            expandButton.widthAnchor.constraint(
                equalToConstant: Constants.Insets.iconSize
            )
        ])
    }
}
