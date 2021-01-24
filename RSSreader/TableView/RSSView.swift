//
//  MainView.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSView: UIView {
    
    // MARK: - Properties
    
    private let cellID = "Cell"
    private var tableView = UITableView()
    private var urlTextField = UITextField()
    
    private var filters = UISegmentedControl()
    private var currenFiler = Filters.none
    
    var presenter: RSSViewPresenterProtocol = RSSViewPresenter()
    
    // MARK: - lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        self.setupViewLayout()
        
        if let text = self.urlTextField.text {
            if let url = URL(string: text) {
                self.presenter.loadRss(url)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension RSSView {
    func setupView() {
        self.backgroundColor = UIColor.systemBackground
        
        self.urlTextField.delegate = self
        self.urlTextField.text = "https://lenta.ru/rss/articles"
        self.urlTextField.borderStyle = UITextField.BorderStyle.roundedRect
        self.urlTextField.font = Fonts.headerStyle.font
        self.urlTextField.clearButtonMode =  UITextField.ViewMode.always
        self.urlTextField.returnKeyType = UIReturnKeyType.done
                
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(RSSCell.self, forCellReuseIdentifier: cellID)
        
        self.filters.insertSegment(withTitle: "Оригинал", at: 0, animated: false)
        self.filters.insertSegment(withTitle: "Ч/Б", at: 1, animated: false)
        self.filters.insertSegment(withTitle: "Сепия", at: 2, animated: false)
        self.filters.selectedSegmentIndex = 0
        
        self.filters.addTarget(self, action: #selector(changeFilters), for: .valueChanged)
    }
    
    func setupViewLayout() {
        self.addSubview(self.urlTextField)
        self.urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.urlTextField.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.horizontalOffset),
            self.urlTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.horizontalOffset),
            self.urlTextField.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: Metrics.horizontalOffset)
        ])
        
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(
                equalTo: self.urlTextField.bottomAnchor,
                constant: Metrics.verticalOffset)
        ])
        
        self.addSubview(self.filters)
        self.filters.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filters.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.horizontalOffset),
            self.filters.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.horizontalOffset),
            self.filters.topAnchor.constraint(
                equalTo: self.tableView.bottomAnchor,
                constant: Metrics.verticalOffset),
            self.filters.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metrics.verticalOffset)
        ])
    }
}

// MARK: - UITableViewDataSource

extension RSSView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.headers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID,
                                                      for: indexPath) as? RSSCell
        
        let header = self.presenter.getHeader(index: indexPath.row)
        let image = self.presenter.getImage(index: indexPath.row, filter: currenFiler)

        cell?.configure(with: header, and: image)
        
        guard let nonOptionalCell = cell else { return UITableViewCell() }
        
        return nonOptionalCell
    }
}

// MARK: - UITableViewDelegate

extension RSSView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.cellHeight
    }
}

// MARK: - UITextFieldDelegate

extension RSSView: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.urlTextField.resignFirstResponder()
        
        if let text = self.urlTextField.text {
            if let url = URL(string: text) {
                self.presenter.loadRss(url)
                self.tableView.reloadData()
            }
        }
        
        return true
    }
}

// MARK: - Filters

private extension RSSView {
    @objc func changeFilters() {
        for index in 0..<self.presenter.currentImages.count {
            switch filters.selectedSegmentIndex {
            case 0:
                self.currenFiler = Filters.none
                self.tableView.reloadData()
            case 1:
                self.currenFiler = Filters.CIPhotoEffectTonal
                self.tableView.reloadData()
            case 2:
                self.currenFiler = Filters.CISepiaTone
                self.tableView.reloadData()
            default:
                break
            }
        }
    }
}
