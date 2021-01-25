//
//  RSSParser.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
        var element = String()
        var rssItemsArray: [RSSItem] = []
        var rssItem = RSSItem(header: "", originalImage: nil, filteredImage: nil)
        var currentFeed = 0
        var counter = -1
        var header = ""
        
        func initWithURL(_ url :URL) -> AnyObject {
            startParse(url)
            return self
        }
        
        func startParse(_ url :URL) {
            parser = XMLParser(contentsOf: url)!
            parser.delegate = self
            parser.shouldProcessNamespaces = false
            parser.shouldReportNamespacePrefixes = false
            parser.shouldResolveExternalEntities = false
            parser.parse()
        }
        
        func allFeeds() -> [RSSItem] {
            return rssItemsArray
        }
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            element = elementName
            
            if elementName == "item" {
                self.rssItem = RSSItem(header: "", originalImage: nil, filteredImage: nil)
                self.header = ""
                self.currentFeed += 1
                self.counter += 1
                self.rssItemsArray.append(rssItem)
            }
            
            if elementName == "enclosure" {
                if let urlString = attributeDict["url"] {
                    rssItemsArray[counter].header += header
                    rssItemsArray[counter].originalImage = ImageExtractor.shared.extractImageFromURL(urlString: urlString)
                    rssItemsArray[counter].filteredImage = rssItemsArray[counter].originalImage
                }
            }
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "item" {
                self.rssItemsArray[counter].header = self.header
            }
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            if element == "title" {
                self.header += string
            }
        }
    }

