//
//  SearchViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

protocol SearchNavigationDelegate: AnyObject {
    
}

final class SearchViewController: BaseViewController {
    var navigationDelegate: SearchNavigationDelegate?
    private lazy var store = SearchStore()
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
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50
        tableView.register(bridgingCellClass: SearchCell.self)
        return tableView
    }()
    
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
            case let .rows(cellModels):
                tableViewDataSourceImpl.cellModels = cellModels
                tableViewDelegateImpl.cellModels = cellModels
                tableView.reloadData()
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
        
    }
}
