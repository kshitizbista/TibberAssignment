//
//  PowerUpDetailViewController.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit
import Combine

class PowerUpDetailViewController: UIViewController {
    
    // MARK: - Properties
    let powerUp: PowerUps
    var subscription = Set<AnyCancellable>()
    
    // MARK: - Views
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 34
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel =  UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let shortDescription: UILabel = {
        let shortDescription =  UILabel()
        shortDescription.translatesAutoresizingMaskIntoConstraints = false
        shortDescription.numberOfLines = 0
        return shortDescription
    }()
    
    private let connectButtton : UIButton = {
        let button = UIButton()
        button.setTitle("Connect To Tibber", for: .normal)
        button.backgroundColor = UIColor(red: 0.137, green: 0.722, blue: 0.8, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buyButtton : UIButton = {
        let button = UIButton()
        button.setTitle("Buy at the Tibber store", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - LifeCyle
    init(powerUp: PowerUps) {
        self.powerUp = powerUp
        super.init(nibName: nil, bundle: nil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        activateConstraints()
    }
    
    // MARK: - Functions
    func setUI() {
        titleLabel.text = powerUp.title
        shortDescription.text = powerUp.description
        descriptionLabel.text = powerUp.longDescription
        descriptionTitleLabel.text = "More About \(powerUp.title)"
        subscribeToAPICall(url: powerUp.imageUrl)
    }
    
    func subscribeToAPICall(url: String) {
        ImageDownloader.download(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.imageView.image = UIImage(systemName: "photo.circle")
                    print(error)
                case .finished: break
                }
            } receiveValue: { [unowned self] image in
                self.imageView.image = image
            }.store(in: &subscription)
    }
}


// MARK: - Layout Configuration
extension PowerUpDetailViewController {
    
    private func addSubviews() {
        view.backgroundColor =  UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(connectButtton)
        contentView.addSubview(buyButtton)
        contentView.addSubview(descriptionView)
        headerView.addSubview(imageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(shortDescription)
        descriptionView.addSubview(descriptionTitleLabel)
        descriptionView.addSubview(descriptionLabel)
    }
    
    private func activateConstraints() {
        activateContainerConstraint()
        activateHeaderViewConstraint()
        activateButtonConstraint()
        activateDescriptionViewConstraint()
    }
    
    private func activateContainerConstraint() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private  func activateHeaderViewConstraint() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 18),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            shortDescription.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            shortDescription.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            shortDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            shortDescription.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func activateButtonConstraint() {
        NSLayoutConstraint.activate([
            connectButtton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            connectButtton.heightAnchor.constraint(equalToConstant: 48),
            connectButtton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22.5),
            connectButtton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22.5),
        ])
        NSLayoutConstraint.activate([
            buyButtton.topAnchor.constraint(equalTo: connectButtton.bottomAnchor, constant: 32),
            buyButtton.heightAnchor.constraint(equalToConstant: 48),
            buyButtton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22.5),
            buyButtton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22.5),
        ])
    }
    
    private func activateDescriptionViewConstraint() {
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: buyButtton.bottomAnchor, constant: 54),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 12),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -10),
        ])
    }
}
