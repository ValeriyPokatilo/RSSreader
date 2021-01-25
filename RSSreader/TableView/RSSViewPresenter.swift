//
//  RSSViewPresenter.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSViewPresenter: RSSViewPresenterProtocol {

    // MARK: - Properties

    var rssItemsArray: [RSSItem] = []
    var rssItemsArrayExport: [RSSItem] = []
    var currentFilter: Filters = Filters.none
    
    var startPosition: Int = -4
    var endPosition: Int = 0
        
    // Methods
    
    func loadRss(_ data: URL) {
        self.rssItemsArray = []
        self.startPosition += 5
        self.endPosition += 5
        
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data,
                                                                         startPosition: startPosition,
                                                                         endPosition: endPosition) as! XmlParserManager
        
        self.rssItemsArray = myParser.rssItemsArray
        self.rssItemsArrayExport += rssItemsArray
    }
    
    func getElement(index: Int) -> RSSItem {
        switch currentFilter {
        case .none:
            rssItemsArrayExport[index].filteredImage = rssItemsArrayExport[index].originalImage
        case .CIPhotoEffectTonal:
            self.rssItemsArrayExport[index].filteredImage = FiltersManager.shared.applyFilter(image: rssItemsArrayExport[index].originalImage!,
                                                                                             filterName: "CIPhotoEffectTonal")
        case .CISepiaTone:
            self.rssItemsArrayExport[index].filteredImage = FiltersManager.shared.applyFilter(image: rssItemsArrayExport[index].originalImage!,
                                                                                             filterName: "CISepiaTone")

        }
        
        return rssItemsArrayExport[index]
    }
}
