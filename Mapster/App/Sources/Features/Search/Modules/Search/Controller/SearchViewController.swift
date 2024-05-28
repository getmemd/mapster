//
//  SearchViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

protocol SearchNavigationDelegate: AnyObject {
    func didTapCategory(_ viewController: SearchViewController, category: AdvertisementCategory)
    func didTapAdvertisement(_ viewController: SearchViewController, advertisement: Advertisement)
}

final class SearchViewController: BaseViewController {
    weak var navigationDelegate: SearchNavigationDelegate?
    private let store: SearchStore
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = SearchTableViewDataSourceImpl(store: store)
    private lazy var tableViewDelegateImpl = SearchTableViewDelegateImpl(store: store)
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.register(bridgingCellClasses: TitleCell.self, TableViewItemCell.self)
        tableView.clipsToBounds = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    init(store: SearchStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
        store.handleAction(.viewDidLoad)
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableViewDelegateImpl.rows = rows
                tableView.reloadData()
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .showError(message):
                showAlert(message: message)
            case let .didSelectCategory(category):
                navigationDelegate?.didTapCategory(self, category: category)
            case let .didSelectAdvertisement(advertisement):
                navigationDelegate?.didTapAdvertisement(self, advertisement: advertisement)
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
        [searchBar, tableView].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store.handleAction(.didStartSearch(searchText: searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
