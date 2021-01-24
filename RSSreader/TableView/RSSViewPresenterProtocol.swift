//
//  RSSViewPresenterProtocol.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

protocol RSSViewPresenterProtocol {
    var headers: NSArray { get set }
    var imagesUrl: [AnyObject] { get set }
    var originalImages: [UIImage] { get set }
    var currentImages: [UIImage] { get set }

    func loadRss(_ data: URL)
    func getHeader(index: Int) -> String
    func getImage(index: Int, filter: Filters) -> UIImage
}
