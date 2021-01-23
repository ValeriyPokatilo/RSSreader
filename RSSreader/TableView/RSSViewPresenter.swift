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
    var images: [AnyObject] = []
        
    func loadRss(_ data: URL) {
        // XmlParserManager instance/object/variable.
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager

        // Put feed in array.
        headers = myParser.headersArray
        images = myParser.imagesArray
        
        print("-=### H \(headers.count)")
        print("-=### I \(images.count)")
    }
    
    func getHeader(index: Int) -> String {
        return (self.headers.object(at: index) as AnyObject).object(forKey: "title") as? String ?? ""
    }
    
    func getImage(index: Int) -> UIImage {
        if  !images.isEmpty {
            let url = NSURL(string: self.images[index] as! String)
            let data = NSData(contentsOf:url! as URL)
            let image = UIImage(data:data! as Data)
            
            return image!
        } else {
            return UIImage()
        }
    }
}
