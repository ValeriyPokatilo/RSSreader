//
//  MainView.swift
//  RSSreader
//
//  Created by Valeriy Pokatilo on 23.01.2021.
//

import UIKit

final class RSSView: UIView {
    
    // MARK: - Properties
    
    private var fetchingMore = false
    
    private let cellID = "Cell"
    private var tableView = UITableView()
    private var urlTextField = UITextField()
    
    private var filters = UISegmentedControl()
    
    private var activityIndicator = UIActivityIndicatorView()
    
    var presenter: RSSViewPresenterProtocol = RSSViewPresenter()
    
    // MARK: - lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        self.setupViewLayout()
        
        self.startParsing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginButchFetch()
            }
        }
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
        
        self.activityIndicator.hidesWhenStopped = true

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
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(
                equalTo: self.centerYAnchor)
        ])

    }
}

// MARK: - UITableViewDataSource

extension RSSView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.rssItemsArrayExport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID,
                                                      for: indexPath) as? RSSCell
        
        let item = self.presenter.getElement(index: indexPath.row)

        if let sendImage = item.filteredImage {
            cell?.configure(with: item.header, and: sendImage)
        } else {
            cell?.configure(with: item.header, and: AssetImages.nophoto.image)
        }
        
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
        
        self.presenter = RSSViewPresenter()
        self.startParsing()

        return true
    }
}

// MARK: - Methods

private extension RSSView {
    @objc func changeFilters() {
        switch filters.selectedSegmentIndex {
        case 0:
            self.presenter.currentFilter = Filters.none
        case 1:
            self.presenter.currentFilter = Filters.CIPhotoEffectTonal
        case 2:
            self.presenter.currentFilter = Filters.CISepiaTone
        default:
            break
        }
        self.tableView.reloadData()
    }


    func startParsing() {
        self.activityIndicator.startAnimating()
        self.filters.isEnabled = false
        self.urlTextField.isEnabled = false
        self.tableView.isScrollEnabled = false

        if let text = self.urlTextField.text {
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                // parsing
                if let url = URL(string: text) {
                    self.presenter.loadRss(url)
                }
                DispatchQueue.main.async {
                    // comeback
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.filters.isEnabled = true
                    self.urlTextField.isEnabled = true
                    self.tableView.isScrollEnabled = true
                }
            }
        }
    }
    
    func beginButchFetch() {
        fetchingMore = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startParsing()
            self.fetchingMore = false
        }
    }
}
