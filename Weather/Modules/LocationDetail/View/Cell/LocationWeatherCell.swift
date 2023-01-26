//
//  LocationCell.swift
//  Locations
//
//  Created by Juan Dario Delgado L on 25/01/23.
//

import UIKit
import Kingfisher

struct LocationWeatherDetailViewModel {
    let description :String
    let date: String
    let avgTemp: Double
    let icon: URL?
}

class LocationWeatherDetailCell: UICollectionViewCell {
    
    // MARK: - Private properties -
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var iconStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        dateLabel.numberOfLines = 0
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var avgTempLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
        layer.cornerRadius = 9
        addViews()
        setUpConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        imageView.image = nil
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods -
    private func addViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconStackView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(avgTempLabel)
        iconStackView.addArrangedSubview(imageView)
        iconStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setUpConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            NSLayoutConstraint(
                item: iconStackView,
                attribute: .height,
                relatedBy: .equal,
                toItem: iconStackView,
                attribute: .width,
                multiplier: 1,
                constant: 0
            )
        ])
    }
    
    // MARK: - Public methods -
    func configure(with viewModel: LocationWeatherDetailViewModel) {
        dateLabel.text = viewModel.date
        descriptionLabel.text = viewModel.description
        imageView.kf.setImage(with: viewModel.icon)
        avgTempLabel.text = "\(viewModel.avgTemp)°"
    }
}
