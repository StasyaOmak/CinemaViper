// MovieInfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Раздел информации фильма
final class MovieInfoTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "MovieInfoTableViewCell"

        enum Texts {
            static let starLabel = "⭐"
            static let watchMovieButton = "Смотреть"
            static let watchMovieButtonIdentifier = "watchMovieButtonIdentifier"
        }

        enum Insets {
            static let imageWidthMultiplier: CGFloat = 0.45
            static let imageHeightMultiplier: CGFloat = 1.4
            static let buttonCornerRadius: CGFloat = 12
            static let buttonHeight: CGFloat = 48
            static let inset: CGFloat = 16
            static let labelWidth: CGFloat = 20
            static let smallInset: CGFloat = 2
            static let minimumHeight: CGFloat = 20
        }
    }

    // MARK: - Visual Components

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Texts.starLabel
        return label
    }()

    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    // swiftlint:disable all
    private let watchMovieButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Texts.watchMovieButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gradientBottom
        button.layer.cornerRadius = Constants.Insets.buttonCornerRadius
        button.accessibilityIdentifier = Constants.Texts.watchMovieButtonIdentifier
        button.addTarget(
            self,
            action: #selector(didTapWatchButton(_:)),
            for: .touchUpInside
        )
        return button
    }()

    // swiftlint:enable all

    // MARK: - Private Properties

    var onTapWatchButton: (() -> ())?

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
        guard let url = info.imageURL else { return }
        loadImage(from: url) { image in
            self.movieImageView.image = image
        }
        movieNameLabel.text = info.movieName
        movieRatingLabel.text = info.movieRating
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubviews([
            movieImageView,
            movieNameLabel,
            starLabel,
            movieRatingLabel,
            watchMovieButton
        ])
    }

    private func setupConstraints() {
        configureMovieImageViewConstraints()
        configureMovieNameLabelConstraints()
        configureStarLabelConstraints()
        configureMovieRatingLabelConstraints()
        configureWatchMovieButtonConstraints()
    }

    private func setupContetnview() {
        contentView.backgroundColor = .yellow
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }

    @objc private func didTapWatchButton(_ sender: UIButton) {
        onTapWatchButton?()
    }
}

/// Pасширение для устоновки размеров и расположения элементов
extension MovieInfoTableViewCell {
    private func configureMovieImageViewConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            movieImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            movieImageView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: Constants.Insets.imageWidthMultiplier
            ),
            movieImageView.heightAnchor.constraint(
                equalTo: movieImageView.widthAnchor,
                multiplier: Constants.Insets.imageHeightMultiplier
            ),
        ])
    }

    private func configureMovieNameLabelConstraints() {
        NSLayoutConstraint.activate([
            movieNameLabel.leadingAnchor.constraint(
                equalTo: movieImageView.trailingAnchor,
                constant: Constants.Insets.inset
            ),
            movieNameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            movieNameLabel.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants
                    .Insets.minimumHeight
            ),
            movieNameLabel.bottomAnchor.constraint(
                equalTo: movieImageView.centerYAnchor,
                constant: -Constants.Insets.smallInset
            )
        ])
    }

    private func configureStarLabelConstraints() {
        NSLayoutConstraint.activate([
            starLabel.leadingAnchor.constraint(
                equalTo: movieImageView.trailingAnchor,
                constant: Constants.Insets.inset
            ),
            starLabel.widthAnchor.constraint(
                equalToConstant: Constants.Insets.labelWidth
            ),
            starLabel.topAnchor.constraint(
                equalTo: movieImageView.centerYAnchor,
                constant: Constants.Insets.smallInset
            ),
            starLabel.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants
                    .Insets.minimumHeight
            )
        ])
    }

    private func configureMovieRatingLabelConstraints() {
        NSLayoutConstraint.activate([
            movieRatingLabel.leadingAnchor.constraint(
                equalTo: starLabel.trailingAnchor,
                constant: Constants.Insets.smallInset
            ),
            movieRatingLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            movieRatingLabel.topAnchor.constraint(
                equalTo: movieImageView.centerYAnchor,
                constant: Constants.Insets.smallInset
            ),
            movieRatingLabel.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants
                    .Insets.minimumHeight
            )
        ])
    }

    private func configureWatchMovieButtonConstraints() {
        NSLayoutConstraint.activate([
            watchMovieButton.topAnchor.constraint(
                equalTo: movieImageView.bottomAnchor,
                constant: Constants.Insets.inset
            ),
            watchMovieButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            watchMovieButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            watchMovieButton.heightAnchor.constraint(
                equalToConstant: Constants.Insets.buttonHeight
            ),
            watchMovieButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }
}
