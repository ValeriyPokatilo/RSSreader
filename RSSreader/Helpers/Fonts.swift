//
//  Fonts.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

enum Fonts {
    case headerStyle

    var font: UIFont {
        switch self {
        case .headerStyle:
            return UIFont.init(name: "AppleSDGothicNeo-Bold", size: 12.0)!
        }
    }
}
