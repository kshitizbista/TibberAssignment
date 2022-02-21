//
//  PowerUpsCollectionViewCell.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit
import Combine

class PowerUpsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PowerUpsCollectionViewCell"
    var subscription = Set<AnyCancellable>()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel =  UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let shortDescription: UILabel = {
        let shortDescription =  UILabel()
        shortDescription.translatesAutoresizingMaskIntoConstraints = false
        shortDescription.numberOfLines = 0
        return shortDescription
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(shortDescription)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func addConstraint() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18))
        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 70))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 70))
        
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18))
        constraints.append(titleLabel.heightAnchor.constraint(equalToConstant: 24))
        
        constraints.append(shortDescription.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16))
        constraints.append(shortDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2))
        
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
