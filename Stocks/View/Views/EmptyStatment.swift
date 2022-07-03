//
//  EmptyStatment.swift
//  Stocks
//
//  Created by Mac on 6/26/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import UIKit

class EmptyStatment: UIView {
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        let image = UIImage(systemName: "dollarsign.square")
        imageView.tintColor = .systemGreen
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Search for companies to calculate potential return via Dollar average."
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = .systemGreen
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layoutUI() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
}
