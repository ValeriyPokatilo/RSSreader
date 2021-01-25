//
//  ImageExtractor .swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class ImageExtractor {
    
    static let shared = ImageExtractor()
    
    func extractImageFromURL(urlString: String) -> UIImage {
        let imageURL: URL = URL(string: urlString)!
        if let data = try? Data(contentsOf: imageURL) {
            return UIImage(data: data)!
        } else {
            return AssetImages.nophoto.image
        }
    }
}
