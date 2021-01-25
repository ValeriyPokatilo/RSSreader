//
//  RSSViewPresenter.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSViewPresenter: RSSViewPresenterProtocol {

    // MARK: - Properties

    var rssItemsArrayExport: [RSSItem] = []
    var currentFilter = Filters.none 
        
    // Methods
    
    func loadRss(_ data: URL) {
        self.rssItemsArrayExport = []
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
        self.rssItemsArrayExport = myParser.rssItemsArray
    }
    
    func getElement(index: Int) -> RSSItem {
        switch currentFilter {
        case .none:
            rssItemsArrayExport[index].filteredImage = rssItemsArrayExport[index].originalImage
        case .CIPhotoEffectTonal:
            rssItemsArrayExport[index].filteredImage = FiltersManager.shared.applyFilter(image: rssItemsArrayExport[index].originalImage!,
                                                                                         filterName: "CIPhotoEffectTonal")
        case .CISepiaTone:
            rssItemsArrayExport[index].filteredImage = FiltersManager.shared.applyFilter(image: rssItemsArrayExport[index].originalImage!,
                                                                                         filterName: "CISepiaTone")
        }
        
        return rssItemsArrayExport[index]
    }
}
