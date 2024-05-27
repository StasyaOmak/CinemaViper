// MovieListCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Переиспользуемая ячейка для показа списка фильмов
final class MovieListCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        enum Insets {
            static let CornerRadius: CGFloat = 10
            static let imageHeight: CGFloat = 200
            static let inset: CGFloat = 8
        }

        enum Texts {
            static let starLabel = "⭐"
        }
    }

    // MARK: - Visual Components

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.Insets.CornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        stackView.addArrangedSubviews([
            nameLabel,
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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Texts.starLabel
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

    static let identifier = "movieListCollectionViewCell"

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
            movieImageView,
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

    func configureWith(movie: Movie) {
        guard let url = movie.imageUrl else { return }
        loadImage(from: url) { image in
            self.movieImageView.image = image
        }
        nameLabel.text = movie.movieName
        guard let rating = movie.rating else { return }
        ratingLabel.text = "\(rating)"
    }
}

// MARK: - MovieListCollectionViewCell

extension MovieListCollectionViewCell {
    private func setMovieImageViewConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            movieImageView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor
            ),
            movieImageView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor
            ),
            movieImageView.heightAnchor.constraint(
                equalToConstant: Constants.Insets.imageHeight
            )
        ])
    }

    private func setMovieInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(
                equalTo: movieImageView.bottomAnchor,
                constant: Constants.Insets.inset
            ),
            infoStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            infoStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
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
