//
//  SectionHeaderReusableView.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    static var identifier = "SectionHeaderReusableView"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func addConstraint() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor))
        constraints.append(titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10))
        constraints.append(titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10))
        NSLayoutConstraint.activate(constraints)
    }
}
