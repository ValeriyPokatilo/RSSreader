//
//  FiltersManager.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 24.01.2021.
//

import UIKit

final class FiltersManager {
    
    static let shared = FiltersManager()
    
    func applyFilter(image: UIImage, filterName: String) -> UIImage {
        let filter = CIFilter(name: filterName)
        
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        let finishImage = UIImage(cgImage: cgImage!)
        
        return finishImage
    }
}
