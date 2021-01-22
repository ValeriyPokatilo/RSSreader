//
//  ViewController.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSViewController: UIViewController {
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        self.view = RSSView()
    }
}

