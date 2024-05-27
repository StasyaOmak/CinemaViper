// MovieDetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран для показа деталей о фильме
final class MovieDetailViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        enum Texts {
            static let movieDetailViewIdentifier = "movieDetailViewIdentifier"
            static let movieDetailTableViewIdentifier = "movieDetailTableViewIdentifier"
            static let isFavoriteButtonIdentifier = "isFavoriteButtonIdentifier"
            static let backButtonIdentifier = "backButtonIdentifier"
            static let titleForAlert = "Упс"
            static let messageForAlert = "Функционал в разработке :("
        }

        enum Insets {
            static let topInset: CGFloat = 20
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
        }
    }

    let sections: [MovieDetailSection] = [.info, .description, .actors, .similar]
    let movieDetailViewModel: MovieDetailViewModel?
    private let id: Int

    // MARK: - Private Properties

    var currentSection: MovieDetailSection = .info
    var isDescriptionExpanded = false
    var isFavorite = false

    // MARK: - Visual Components

    private let gradientLayer = CAGradientLayer()

    private let backBarButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronLeft, for: .normal)
        button.accessibilityIdentifier = Constants.Texts.backButtonIdentifier
        return button
    }()

    private let isFavoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(.isNotFavorite, for: .normal)
        button.accessibilityIdentifier = Constants.Texts.isFavoriteButtonIdentifier
        return button
    }()

    private lazy var movieDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MovieInfoTableViewCell.self,
            forCellReuseIdentifier: MovieInfoTableViewCell.Constants.identifier
        )
        tableView.register(
            DescriptionTableViewCell.self,
            forCellReuseIdentifier: DescriptionTableViewCell.Constants.identifier
        )
        tableView.register(
            OtherInfoTableViewCell.self,
            forCellReuseIdentifier: OtherInfoTableViewCell.Constants.identifier
        )
        tableView.register(
            ActorsTableViewCell.self,
            forCellReuseIdentifier: ActorsTableViewCell.Constants.identifier
        )
        tableView.register(
            LanguagesTableViewCell.self,
            forCellReuseIdentifier: LanguagesTableViewCell.Constants.identifier
        )
        tableView.register(
            SimilarMoviesTableViewCell.self,
            forCellReuseIdentifier: SimilarMoviesTableViewCell.Constants.identifier
        )
        tableView.register(
            MovieInfoShimmerTableViewCell.self,
            forCellReuseIdentifier: "MovieInfoShimmerTableViewCell"
        )
        tableView.register(
            RecommendedShimmerCell.self,
            forCellReuseIdentifier: "RecommendedShimmerCell"
        )
        tableView.register(
            CastShimmerCell.self,
            forCellReuseIdentifier: "CastShimmerCell"
        )

        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.accessibilityIdentifier = Constants.Texts.movieDetailTableViewIdentifier
        return tableView
    }()

    // MARK: - Initializers

    init(id: Int, movieDetailViewModel: MovieDetailViewModel?) {
        self.movieDetailViewModel = movieDetailViewModel
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailViewModel?.fetchMovie {
            self.movieDetailTableView.reloadData()
        }
        setupGradientLayer()
        setupSubviews()
        configureSubviews()
        setupNavigationBar()
        updateIsFavoriteButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        view.addSubviews([
            movieDetailTableView
        ])
    }

    private func configureSubviews() {
        configureMovieDetailTableViewConstrints()
    }

    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.gradientTop.cgColor,
            UIColor.gradientBottom.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        view.accessibilityIdentifier = Constants.Texts.movieDetailViewIdentifier
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .default
        )
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: backBarButton
        )
        backBarButton.addTarget(
            self,
            action: #selector(didTapBackButton(_:)),
            for: .touchUpInside
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: isFavoriteButton)
        isFavoriteButton.addTarget(
            self,
            action: #selector(didTapIsFavoriteButton(_:)),
            for: .touchUpInside
        )
    }

    private func toggleIsFavoriteButtonState() {
        isFavorite.toggle()
        setIsFavoriteButton(isFavorite: isFavorite)
        let defaults = UserDefaults.standard
        defaults.set(isFavorite, forKey: "\(id)")
    }

    private func updateIsFavoriteButton() {
        let isFavorite = UserDefaults.standard.bool(forKey: "\(id)")
        setIsFavoriteButton(isFavorite: isFavorite)
        self.isFavorite = isFavorite
    }

    private func setIsFavoriteButton(isFavorite: Bool) {
        let favoriteImage: UIImage = isFavorite
            ? .isFavorite
            : .isNotFavorite
        isFavoriteButton.setImage(favoriteImage, for: .normal)
    }

    @objc private func didTapBackButton(_ sender: UIButton) {
        movieDetailViewModel?.backToMoviesList()
    }

    @objc private func didTapIsFavoriteButton(_ sender: UIButton) {
        toggleIsFavoriteButtonState()
    }
}

// MARK: - Extensions

extension MovieDetailViewController {
    private func showAlertForWatchButton() {
        let alertViewController = UIAlertController(
            title: Constants.Texts.titleForAlert,
            message: Constants.Texts.messageForAlert,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default
        )
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }
}

// MARK: - MovieDetailViewController + UITableViewDataSource

extension MovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch movieDetailViewModel?.state {
        case let .data(movieDetail):
            currentSection = sections[section]
            switch currentSection {
            case .description, .actors:
                return 2
            default:
                return 1
            }
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch movieDetailViewModel?.state {
        case .loading:
            switch sections[indexPath.section] {
            case .info:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MovieInfoShimmerTableViewCell.identifier,
                    for: indexPath
                ) as? MovieInfoShimmerTableViewCell else { return UITableViewCell() }
                cell.startShimmers()
                cell.backgroundColor = .clear
                return cell
            case .description:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CastShimmerCell.identifier,
                    for: indexPath
                ) as? CastShimmerCell else { return UITableViewCell() }
                cell.startShimmers()
                return cell
            case .actors:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecommendedShimmerCell.identifier,
                    for: indexPath
                ) as? RecommendedShimmerCell else { return UITableViewCell() }
                cell.startShimmers()
                return cell
            case .similar:
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        case let .data(movieDetail):
            switch sections[indexPath.section] {
            case .info:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MovieInfoTableViewCell.Constants.identifier,
                    for: indexPath
                ) as? MovieInfoTableViewCell else { return UITableViewCell() }
                cell.configureCell(info: movieDetail)
                cell.onTapWatchButton = { [weak self] in
                    self?.showAlertForWatchButton()
                }
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            case .description:
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DescriptionTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? DescriptionTableViewCell else { return UITableViewCell() }
                    cell.configureCell(info: movieDetail)
                    cell.onExpandButtonTap = { [weak self] in
                        self?.movieDetailTableView.beginUpdates()
                        self?.movieDetailTableView.setNeedsDisplay()
                        self?.movieDetailTableView.endUpdates()
                    }
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: OtherInfoTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? OtherInfoTableViewCell else { return UITableViewCell() }
                    cell.configureCell(info: movieDetail)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                }
            case .actors:
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: ActorsTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? ActorsTableViewCell else { return UITableViewCell() }
                    print("movieDetail is \(movieDetail)")
                    cell.configureCell(info: movieDetail)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: LanguagesTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? LanguagesTableViewCell else { return UITableViewCell() }
                    cell.configureCell(info: movieDetail)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                }

            case .similar:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SimilarMoviesTableViewCell.Constants.identifier,
                    for: indexPath
                ) as? SimilarMoviesTableViewCell else { return UITableViewCell() }
                cell.configureCell(info: movieDetail)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

// MARK: - MovieDetailViewController

extension MovieDetailViewController {
    private func configureMovieDetailTableViewConstrints() {
        NSLayoutConstraint.activate([
            movieDetailTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.Insets.topInset
            ),
            movieDetailTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Insets.leading
            ),
            movieDetailTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.Insets.trailing
            ),
            movieDetailTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}
