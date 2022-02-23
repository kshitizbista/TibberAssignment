//
//  SectionHeaderReusableView.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    // MARK: - Properties
    static var identifier = "SectionHeaderReusableView"
    
    // MARK: - Views
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        activateConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func activateConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
