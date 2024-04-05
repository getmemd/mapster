//
//  SearchViewController.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

protocol SearchNavigationDelegate: AnyObject {
    
}

final class SearchViewController: BaseViewController {
    var navigationDelegate: SearchNavigationDelegate?
    private lazy var store = SearchStore()
    private var bag = Bag()
    // Настройка данных для таблицы
    private lazy var tableViewDataSourceImpl = SearchTableViewDataSourceImpl(store: store)
    // Настройка делегатов для таблицы
    private lazy var tableViewDelegateImpl = SearchTableViewDelegateImpl(store: store)
    
    // Поле поиска
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        return searchBar
    }()
    
    // Таблица категорий в поиске
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50
        tableView.register(bridgingCellClass: TableViewItemCell.self)
        tableView.clipsToBounds = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
        store.handleAction(.viewDidLoad)
    }
    
    // Настройка наблюдателей эвентов от стора
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
    // Делегат срабатывает при изменении текста в строке поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
