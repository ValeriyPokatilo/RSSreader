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
        var image = UIImage()
        
        let imageURL: URL = URL(string: urlString)!
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            if let data = try? Data(contentsOf: imageURL){
                DispatchQueue.main.async {
                    image = UIImage(data: data)!
                }
            }
        }
        
        return image
    }
}
