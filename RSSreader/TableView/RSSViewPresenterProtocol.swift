//
//  RSSViewPresenterProtocol.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

protocol RSSViewPresenterProtocol {
    var headers: NSArray { get set }
    var images: [AnyObject] { get set }

    func loadRss(_ data: URL)
    func getHeader(index: Int) -> String
    func getImage(index: Int) -> UIImage
}
