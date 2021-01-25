//
//  RSSViewPresenterProtocol.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

protocol RSSViewPresenterProtocol {
    var rssItemsArrayExport: [RSSItem] { get }
    var currentFilter: Filters { get set }

    func loadRss(_ data: URL)
    func getElement(index: Int) -> RSSItem
}
