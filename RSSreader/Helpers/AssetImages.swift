//
//  AssetImages.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

enum AssetImages: String {
    case nophoto = "nophoto"

    var image: UIImage {
        guard let image = UIImage(named: self.rawValue) else {
            assertionFailure()
            return UIImage()
        }
        return image
    }
}
