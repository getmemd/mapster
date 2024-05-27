//
//  AdvertisementsListViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import UIKit

protocol AdvertisementsListNavigationDelegate: AnyObject {
    func didTapAdvertisement(_ viewController: AdvertisementsListViewController, advertisement: Advertisement)
    func didDeleteAdvertisement(_ viewController: AdvertisementsListViewController)
}

final class AdvertisementsListViewController: BaseViewController {
    weak var navigationDelegate: AdvertisementsListNavigationDelegate?
    private let store: AdvertisementsListStore
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = AdvertisementsListTableViewDataSourceImpl(store: store)
    private lazy var tableViewDelegateImpl = AdvertisementsListTableViewDelegateImpl(store: store)
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160
        tableView.register(bridgingCellClasses: TitleCell.self, AdvertisementsListCell.self, AdvertisementsListEmptyCell.self)
        tableView.clipsToBounds = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        store.handleAction(.loadData)
    }
    
    init(store: AdvertisementsListStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func refreshData() {
        store.handleAction(.loadData)
    }
    
    private func presentDeleteConfirmation(viewState: AdvertisementsListViewState, completion: @escaping (() -> Void)) {
        let title = viewState == .myAdvertisements ? "Вы уверены что хотите удалить объявление?" : "Вы уверены что хотите убрать объявление из избранного?"
        let alertController = UIAlertController(title: title,
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "Да", style: .destructive) { _ in
            completion()
        })
        alertController.addAction(.init(title: "Нет", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableViewDelegateImpl.rows = rows
                tableView.reloadData()
                refreshControl.endRefreshing()
            case let .showError(message):
                showAlert(message: message)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .advertisementSelected(advertisement):
                navigationDelegate?.didTapAdvertisement(self, advertisement: advertisement)
            case .advertisementDeleted:
                navigationDelegate?.didDeleteAdvertisement(self)
            case let .confirmAdvertisementDeletion(viewState, completion):
                presentDeleteConfirmation(viewState: viewState, completion: completion)
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
