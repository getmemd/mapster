//
//  ProfileViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import UIKit

protocol ProfileNavigationDelegate: AnyObject {
    func didTapEdit(_ viewController: ProfileViewController)
    func didSignOut(_ viewController: ProfileViewController)
}

final class ProfileViewController: BaseViewController {
    weak var navigationDelegate: ProfileNavigationDelegate?
    private lazy var store = ProfileStore()
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = ProfileTableViewDataSourceImpl(store: store)
    private lazy var tableViewDelegateImpl = ProfileTableViewDelegateImpl(store: store)

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160
        tableView.register(bridgingCellClasses: ProfileCell.self, TableViewItemCell.self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        store.handleAction(.viewDidLoad)
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableViewDelegateImpl.rows = rows
                tableView.reloadData()
            case .signOutCompleted:
                navigationDelegate?.didSignOut(self)
            case let .showError(message):
                showAlert(message: message)
            case .editProfileTapped:
                navigationDelegate?.didTapEdit(self)
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
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
