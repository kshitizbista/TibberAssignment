//
//  PowerUpDetailViewController.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit
import Combine
import SafariServices

class PowerUpDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var powerUp: PowerUps
    private var subscription = Set<AnyCancellable>()
    let didConnectButtonTap = PassthroughSubject<PowerUps, Never>()
    
    // MARK: - Views
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
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
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let shortDescription: UILabel = {
        let shortDescription =  UILabel()
        shortDescription.translatesAutoresizingMaskIntoConstraints = false
        shortDescription.numberOfLines = 0
        shortDescription.font = .systemFont(ofSize: 16)
        shortDescription.textColor = UIColor(named: K.BrandColor.titleSmall)
        return shortDescription
    }()
    
    private let buttonViews: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: K.BrandColor.backgroundGrey)
        return view
    }()
    
    private let connectButtton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
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
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.textColor = UIColor(named: K.BrandColor.titleSmall)
        return label
    }()
    
    
    // MARK: - LifeCyle
    init(powerUp: PowerUps) {
        self.powerUp = powerUp
        super.init(nibName: nil, bundle: nil)
        setUIState()
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
    private func setUIState() {
        titleLabel.text = powerUp.title
        shortDescription.text = powerUp.description
        descriptionLabel.text = powerUp.longDescription
        descriptionTitleLabel.text = "More About \(powerUp.title)"
        updateConnectButtonState(isConnected: powerUp.connected)
        subscribeToAPICall(url: powerUp.imageUrl)
    }
    
    private func subscribeToAPICall(url: String) {
        ImageDownloader.download(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.imageView.image = UIImage(systemName: "photo.circle")
                    print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] image in
                self?.imageView.image = image
            }.store(in: &subscription)
    }
    
    @objc private func connectButtonTapped() {
        powerUp.connected = !powerUp.connected
        updateConnectButtonState(isConnected: powerUp.connected)
        didConnectButtonTap.send(powerUp)
    }
    
    @objc private func buyButtonTapped() {
        if let url = URL(string: powerUp.storeUrl) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    private func updateConnectButtonState(isConnected: Bool) {
        if !isConnected {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.connectButtton.setTitle("Connect To Tibber", for: .normal)
                self.connectButtton.setTitleColor(.white, for: .normal)
                self.connectButtton.backgroundColor = UIColor(named: K.BrandColor.brandPrimary)
                self.connectButtton.layer.borderColor = nil
                self.connectButtton.layer.borderWidth = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.connectButtton.setTitle("Disconnect from Tibber", for: .normal)
                self.connectButtton.setTitleColor(.red, for: .normal)
                self.connectButtton.layer.borderColor = UIColor.red.cgColor
                self.connectButtton.layer.borderWidth = 1
                self.connectButtton.backgroundColor = nil
            })
        }
    }
}

// MARK: - Layout Configuration
extension PowerUpDetailViewController {
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(descriptionView)
        contentView.addSubview(buttonViews)
        headerView.addSubview(imageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(shortDescription)
        buttonViews.addSubview(connectButtton)
        buttonViews.addSubview(buyButtton)
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
            imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 96),
            imageView.heightAnchor.constraint(equalToConstant: 96)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
        ])
        NSLayoutConstraint.activate([
            shortDescription.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            shortDescription.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            shortDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            shortDescription.bottomAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor, constant: -16),
        ])
    }
    
    private func activateButtonConstraint() {
        NSLayoutConstraint.activate([
            buttonViews.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            buttonViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonViews.bottomAnchor.constraint(equalTo: descriptionView.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            connectButtton.topAnchor.constraint(equalTo: buttonViews.topAnchor, constant: 32),
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

// MARK: - Safari Delegate
extension PowerUpDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
