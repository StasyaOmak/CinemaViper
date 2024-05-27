// ActorsCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Переиспользуемая ячейка для показа категорий
final class ActorsCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        enum Insets {
//            static let CornerRadius: CGFloat = 16
        }

        enum Texts {}
    }

    // MARK: - Visual Components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 8)
        return label
    }()

    // MARK: - Public Properties

    let identifier = "ActorsCollectionViewCellIdentifier"

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
            fullNameLabel
        ])
    }

    private func configureLayout() {
        configureImageViewConstraints()
        configureFullNameLabelConstraints()
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

    func configureWith(data: MovieActor) {
        guard let url = URL(string: data.imageURL ?? "")
        else { return }
        print("url \(url)")
        loadImage(from: url) { image in
            self.imageView.image = image
        }
        fullNameLabel.text = data.name
    }
}

/// Pасширение для устоновки размеров и расположения элементов
extension ActorsCollectionViewCell {
    private func configureImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 7
            ),
            imageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -7
            ),
            imageView.heightAnchor.constraint(equalToConstant: 73)
        ])
    }

    private func configureFullNameLabelConstraints() {
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 6
            ),
            fullNameLabel.centerXAnchor.constraint(
                equalTo: imageView.centerXAnchor
            ),
            fullNameLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }
}
