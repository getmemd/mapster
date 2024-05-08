//
//  FavouritesViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

protocol FavouritesNavigationDelegate: AnyObject {
    func didTapAdvertisement(_ viewController: FavouritesViewController, advertisement: Advertisement)
}

final class FavouritesViewController: BaseViewController {
    weak var navigationDelegate: FavouritesNavigationDelegate?
    private lazy var store = FavouritesStore()
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = FavouritesTableViewDataSourceImpl(store: store)
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
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .advertisementSelected(advertisement):
                navigationDelegate?.didTapAdvertisement(self, advertisement: advertisement)
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
