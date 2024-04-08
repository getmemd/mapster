//
//  FavouritesViewController.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import UIKit

protocol FavouritesNavigationDelegate: AnyObject {
    
}

final class FavouritesViewController: BaseViewController {
    var navigationDelegate: FavouritesNavigationDelegate?
    private lazy var store = FavouritesStore()
    private var bag = Bag()
    // Настройка данных для таблицы
    private lazy var tableViewDataSourceImpl = FavouritesTableViewDataSourceImpl(store: store)
    // Настройка делегатов для таблицы
    private lazy var tableViewDelegateImpl = FavouritesTableViewDelegateImpl(store: store)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 160
        tableView.register(bridgingCellClasses: TitleCell.self, FavouritesCell.self, FavouritesEmptyCell.self)
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
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableViewDelegateImpl.rows = rows
                tableView.reloadData()
            case let .showError(message):
                showAlert(message: message)
            case .loading:
                activityIndicator.startAnimating()
            case .loadingFinished:
                activityIndicator.stopAnimating()
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
