//
//  RSSCell.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSCell: UITableViewCell {
    
    // MARK: - Proprties
    
    var headerLabel = UILabel()
    var headerImage = UIImageView()
    
    // MARK: - Lifecycle
    
    func configure(with header: String, and image: UIImage) {
        self.setupView(header, image)
        self.setupViewLayout()
    }
}

// MARK: - Setup layout

private extension RSSCell {
    func setupView(_ header: String, _ image: UIImage) {
        self.headerLabel.text = header
        self.headerLabel.font = Fonts.headerStyle.font
        self.headerLabel.textColor = UIColor.darkGray
        self.headerLabel.numberOfLines = 6
        self.headerLabel.textAlignment = NSTextAlignment.justified

        self.headerImage.image = image
        self.headerImage.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    func setupViewLayout() {
        self.headerImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerImage)
        
        NSLayoutConstraint.activate([
            self.headerImage.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.cellOffset),
            self.headerImage.widthAnchor.constraint(
                equalToConstant: Metrics.cellImageWidth),
            self.headerImage.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: Metrics.cellOffset),
            self.headerImage.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metrics.cellOffset),
        ])
        
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerLabel)
        
        NSLayoutConstraint.activate([
            self.headerLabel.leadingAnchor.constraint(
                equalTo: self.headerImage.trailingAnchor,
                constant: Metrics.horizontalOffset),

            self.headerLabel.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.horizontalOffset),

            self.headerLabel.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: Metrics.cellOffset),

            self.headerLabel.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metrics.cellOffset),
        ])
    }
}
