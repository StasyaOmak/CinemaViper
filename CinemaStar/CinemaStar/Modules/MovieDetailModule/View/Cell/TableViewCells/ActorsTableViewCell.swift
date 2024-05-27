// ActorsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Раздел с актёрами
final class ActorsTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "ActorsTableViewCell"
        static let actorsCollectionViewIdentifier = "actorsCollectionViewIdentifier"

        enum Texts {
            static let titleLabel = "Актеры и съемочная группа "
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
        label.textColor = .white
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.accessibilityIdentifier = "actorsCollectionViewIdentifier"
        return collectionView
    }()

    // MARK: - Private Properties

    private var actors: [MovieActor]?

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
        actors = info.actors
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
            ActorsCollectionViewCell.self,
            forCellWithReuseIdentifier: ActorsCollectionViewCell().identifier
        )
    }

    private func setupConstraints() {
        setTitleLabelConstraints()
        setCollectionViewConstraints()
    }

    private func setupContetnview() {
        contentView.backgroundColor = .yellow
    }
}

// MARK: - ActorsTableViewCell + UICollectionViewDataSource

extension ActorsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let actors = actors else { return 100 }
        return actors.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ActorsCollectionViewCellIdentifier",
            for: indexPath
        ) as? ActorsCollectionViewCell
        else { return UICollectionViewCell() }

        if let actors = actors {
            print("actors are \(actors)")
            cell.configureWith(data: actors[indexPath.row])
        }

        return cell
    }
}

// MARK: - ActorsTableViewCell + UICollectionViewDelegateFlowLayout

extension ActorsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 60, height: 100)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        100
    }
}

// MARK: - ActorsTableViewCell

extension ActorsTableViewCell {
    private func setTitleLabelConstraints() {
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

    private func setCollectionViewConstraints() {
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
                equalToConstant: 100
            )
        ])
    }
}
