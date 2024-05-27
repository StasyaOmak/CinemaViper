// SimilarMoviesTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Похожие фильмы
final class SimilarMoviesTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "SimilarMoviesTableViewCell"

        enum Texts {
            static let titleLabel = "Смотрите также"
        }

        enum Insets {
            static let verticalInset: CGFloat = 13
            static let leading: CGFloat = 6
        }
    }

    // MARK: - Visual Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.text = Constants.Texts.titleLabel
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 50
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Private Properties

    private var similarMovies: [Movie]?

    // MARK: - Initalizers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupContetnview()
        configureCollectionView()
    }

    // MARK: - Public Methods

    func configureCell(info: MovieDetail) {
        similarMovies = info.similarMovies
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubviews([
            titleLabel,
            collectionView
        ])
    }

    private func configureCollectionView() {
        collectionView.register(
            SimilarMoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: SimilarMoviesCollectionViewCell().identifier
        )
    }

    private func setupConstraints() {
        configureTitleLabelConstraints()
        configureCollectionViewConstraints()
    }

    private func setupContetnview() {
        contentView.backgroundColor = .yellow
    }
}

// MARK: - SimilarMoviesTableViewCell

extension SimilarMoviesTableViewCell {
    private func configureTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor
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

    private func configureCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.Insets.verticalInset
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            collectionView.heightAnchor.constraint(
                equalToConstant: 200
            ),
            collectionView.widthAnchor.constraint(
                equalToConstant: 300
            )
        ])
    }
}

// MARK: - SimilarMoviesTableViewCell + UICollectionViewDataSource

extension SimilarMoviesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let similarMovies = similarMovies else { return 1 }
        return similarMovies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SimilarMoviesCollectionViewCell().identifier,
            for: indexPath
        ) as? SimilarMoviesCollectionViewCell
        else { return UICollectionViewCell() }

        if let similarMovies = similarMovies {
            cell.configureWith(data: similarMovies[indexPath.row])
        }

        return cell
    }
}

// MARK: - SimilarMoviesTableViewCell + UICollectionViewDelegateFlowLayout

extension SimilarMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 170, height: 248)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        100
    }
}
