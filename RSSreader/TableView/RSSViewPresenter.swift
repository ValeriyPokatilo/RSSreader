//
//  RSSViewPresenter.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSViewPresenter: RSSViewPresenterProtocol {
    
    // MARK: - Properties

    var headers: NSArray = []
    var imagesUrl: [AnyObject] = []
    var originalImages: [UIImage] = []
    var currentImages: [UIImage] = []
        
    func loadRss(_ data: URL) {
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager

        headers = myParser.headersArray
        imagesUrl = myParser.imagesArray
        
        for item in imagesUrl {
            let url = NSURL(string: item as! String)
            let data = NSData(contentsOf:url! as URL)
            let image = UIImage(data:data! as Data)
            
            if let image = image {
                originalImages.append(image)
                currentImages.append(image)
            }
        }
    }
    
    func getHeader(index: Int) -> String {
        return (self.headers.object(at: index) as AnyObject).object(forKey: "title") as? String ?? ""
    }
    
    func getImage(index: Int, filter: Filters) -> UIImage {
        switch filter {
        case .none :
            return originalImages[index]
        case .CIPhotoEffectTonal:
            return FiltersManager.shared.applyFilter(image: currentImages[index], filterName: "CIPhotoEffectTonal")
        case .CISepiaTone:
            return FiltersManager.shared.applyFilter(image: currentImages[index], filterName: "CISepiaTone")
        }
    }
}
