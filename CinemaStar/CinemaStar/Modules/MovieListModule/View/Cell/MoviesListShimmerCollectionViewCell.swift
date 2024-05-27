// MoviesListShimmerCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка для фильмов
final class MoviesListShimmerCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        enum Insets {
            static let CornerRadius: CGFloat = 8
            static let imageHeight: CGFloat = 200
            static let inset: CGFloat = 8
        }

        enum Texts {
            static let starLabel = "⭐"
        }
    }

    // MARK: - Visual Components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .shimmer
        imageView.layer.cornerRadius = Constants.Insets.CornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .shimmer

        stackView.addArrangedSubviews([
            movieNameLabel,
            ratingStackView
        ])
        return stackView
    }()

    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        stackView.addArrangedSubviews([
            starLabel,
            ratingLabel
        ])
        return stackView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - Public Properties

    static let identifier = "moviesListShimmerCollectionViewCell"

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        configureLayout()
        setupContentView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubviews([
            imageView,
            infoStackView
        ])
    }

    private func configureLayout() {
        setMovieImageViewConstraints()
        setMovieInfoStackViewConstraints()
        setStarLabelConstraints()
    }

    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = Constants.Insets.CornerRadius
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

    // MARK: - Configuration

    func startShimming() {
        layoutIfNeeded()
        imageView.startShimmeringAnimation(animationSpeed: 1.5)
        infoStackView.startShimmeringAnimation(animationSpeed: 1.5)
    }
}

// MARK: - MoviesListShimmerCollectionViewCell

extension MoviesListShimmerCollectionViewCell {
    private func setMovieImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            imageView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor
            ),
            imageView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: Constants.Insets.imageHeight
            )
        ])
    }

    private func setMovieInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: Constants.Insets.inset
            ),
            infoStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            infoStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }

    private func setStarLabelConstraints() {
        NSLayoutConstraint.activate([
            starLabel.widthAnchor.constraint(
                equalToConstant: 20
            )
        ])
    }
}
