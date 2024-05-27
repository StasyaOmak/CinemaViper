// SimilarMoviesCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Переиспользуемая ячейка для показа категорий
final class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        enum Insets {
//            static let CornerRadius: CGFloat = 16
        }

        enum Texts {}
    }

    // MARK: - Visual Components

    lazy var similarMovieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .clear

        stackView.addArrangedSubviews([
            imageView,
            movieNameLabel
        ])
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "text"
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Public Properties

    let identifier = "SimilarMoviesCollectionViewCell"

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
            similarMovieStackView
        ])
    }

    private func configureLayout() {
        configureImageViewConstraints()
        configureMovieNameLabelConstraints()
    }

    private func setupContentView() {
        contentView.backgroundColor = .clear
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

    func configureWith(data: Movie) {
        guard let url = data.imageUrl else { return }
        loadImage(from: url) { image in
            self.imageView.image = image
        }
        movieNameLabel.text = "aaaaa"
    }
}

/// Pасширение для устоновки размеров и расположения элементов
extension SimilarMoviesCollectionViewCell {
    private func configureImageViewConstraints() {
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(
//                equalTo: contentView.topAnchor
//            ),
//            imageView.leadingAnchor.constraint(
//                equalTo: contentView.leadingAnchor
//            ),
//            imageView.trailingAnchor.constraint(
//                equalTo: contentView.trailingAnchor
//            )
//        ])
    }

    private func configureMovieNameLabelConstraints() {
        NSLayoutConstraint.activate([
            similarMovieStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            similarMovieStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            similarMovieStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            similarMovieStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }
}
