// MoviesListViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран для показа списка фильмов
final class MoviesListViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        enum Texts {
            static let descriptionTitleLabel = "Смотри исторические \nфильмы на "
            static let nameTitleLabel = "CINEMA STAR"
            static let moviesCollectionViewIdentifier = "moviesCollectionViewIdentifier"
        }

        enum Insets {
            static let topInset: CGFloat = 64
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
            static let titleHeight: CGFloat = 50
            static let inset: CGFloat = 15
        }
    }

    let moviesListViewModel: MoviesListViewModel?

    // MARK: - Visual Components

    private let gradientLayer = CAGradientLayer()

    private lazy var titleLabel = makeLabelWithAttributedText(
        regularText: Constants.Texts.descriptionTitleLabel,
        boldText: Constants.Texts.nameTitleLabel
    )

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.accessibilityIdentifier = Constants.Texts.moviesCollectionViewIdentifier
        return collectionView
    }()

    // MARK: - Initializers

    init(moviesListViewModel: MoviesListViewModel?) {
        self.moviesListViewModel = moviesListViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        moviesListViewModel?.fetchMovies {
            self.collectionView.reloadData()
        }

        setupGradientLayer()
        setupSubviews()
        configureSubviews()
        configureCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        view.addSubviews([
            titleLabel,
            collectionView
        ])
    }

    private func configureSubviews() {
        configureTitleLabelConstrints()
        configureCollectionViewConstraints()
    }

    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.gradientTop.cgColor,
            UIColor.gradientBottom.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }

    private func configureCollectionView() {
        collectionView.register(
            MovieListCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier
        )
        collectionView.register(
            MoviesListShimmerCollectionViewCell.self,
            forCellWithReuseIdentifier: MoviesListShimmerCollectionViewCell.identifier
        )
    }
}

// MARK: - MoviesListViewController + UICollectionViewDataSource

extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch moviesListViewModel?.state {
        case .loading:
            return 6
        case let .data(movies):
            return movies.count
        default:
            return 1
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch moviesListViewModel?.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MoviesListShimmerCollectionViewCell.identifier,
                for: indexPath
            ) as? MoviesListShimmerCollectionViewCell else { return UICollectionViewCell() }
            cell.startShimming()
            return cell
        case let .data(movies):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieListCollectionViewCell.identifier,
                for: indexPath
            ) as? MovieListCollectionViewCell else { return UICollectionViewCell() }
            cell.configureWith(movie: movies[indexPath.item])

            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
}

// MARK: - MoviesListViewController

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: 170,
            height: 250
        )
    }
}

// MARK: - MoviesListViewController + UICollectionViewDelegate

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch moviesListViewModel?.state {
        case let .data(movies):
            moviesListViewModel?.moveToMovieDetailScreen(
                id: movies[indexPath.row].id
            )
            print(movies[indexPath.row].id)
        default:
            break
        }
    }
}

// MARK: - MoviesListViewController

extension MoviesListViewController {
    private func configureTitleLabelConstrints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constants.Insets.topInset
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Insets.leading
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.Insets.trailing
            ),
            titleLabel.heightAnchor.constraint(
                equalToConstant: Constants.Insets.titleHeight
            )
        ])
    }

    private func configureCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.Insets.inset
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Insets.leading
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.Insets.trailing
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }
}
