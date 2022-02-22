//
//  BadgeView.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-22.
//



import UIKit

class DisclosureAccessoryReusableView: UICollectionReusableView {
    
    static let identifier = "DisclosureAccessoryReusableView"
    private var imageView: UIImageView = {
        let label = UIImageView(image: UIImage(systemName: "chevron.right"))
        label.tintColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func addConstraint() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(imageView.centerYAnchor.constraint(equalTo: centerYAnchor))
        constraints.append(imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -10))
        NSLayoutConstraint.activate(constraints)
    }
}
