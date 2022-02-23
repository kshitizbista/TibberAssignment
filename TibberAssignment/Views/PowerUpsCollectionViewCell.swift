//
//  PowerUpsCollectionViewCell.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit
import Combine

class PowerUpsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "PowerUpsCollectionViewCell"
    var subscription = Set<AnyCancellable>()
    
    // MARK: - Views
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
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
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(shortDescription)
        activateConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func activateConstraint() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        
        constraints.append(imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 70))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 70))
        
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16))
        constraints.append(titleLabel.heightAnchor.constraint(equalToConstant: 24))

        constraints.append(shortDescription.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16))
        constraints.append(shortDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56))
        constraints.append(shortDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2))
        constraints.append(shortDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func configure(model: PowerUps) {
        subscription.removeAll()
        ImageDownloader.download(url: model.imageUrl)
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
        titleLabel.text = model.title
        shortDescription.text = model.description
    }
}
