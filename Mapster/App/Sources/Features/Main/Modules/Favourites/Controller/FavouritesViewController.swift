//
//  FavouritesViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

protocol FavouritesNavigationDelegate: AnyObject {
    
}

final class FavouritesViewController: BaseViewController {
    var navigationDelegate: FavouritesNavigationDelegate?
    private lazy var store = FavouritesStore()
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = FavouritesTableViewDataSourceImpl(store: store)
    private lazy var tableViewDelegateImpl = FavouritesTableViewDelegateImpl(store: store)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Избранное"
        label.font = Font.mulish(name: .bold, size: 22)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 160
        tableView.register(bridgingCellClasses: FavouritesCell.self, FavouritesEmptyCell.self)
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
        [titleLabel, tableView].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
