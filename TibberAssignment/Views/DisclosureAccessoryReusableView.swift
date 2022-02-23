//
//  BadgeView.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-22.
//



import UIKit

class DisclosureAccessoryReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier = "DisclosureAccessoryReusableView"
    
    // MARK: - Views
    private var imageView: UIImageView = {
        let label = UIImageView(image: UIImage(systemName: "chevron.right"))
        label.tintColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        activateConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func activateConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -10)
        ])
    }
}
