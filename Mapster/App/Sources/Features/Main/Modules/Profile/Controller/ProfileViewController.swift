//
//  ProfileViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 05.04.2024.
//

import UIKit

protocol ProfileNavigationDelegate: AnyObject {
    func didSignOut(_ viewController: ProfileViewController)
}

final class ProfileViewController: BaseViewController {
    weak var navigationDelegate: ProfileNavigationDelegate?
    private lazy var store = ProfileStore()
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = ProfileTableViewDataSourceImpl(store: store)
    private lazy var tableViewDelegateImpl = ProfileTableViewDelegateImpl(store: store)
    
    private let circularView = CircularView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Font.mulish(name: .bold, size: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Font.mulish(name: .regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.delegate = tableViewDelegateImpl
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160
        tableView.register(bridgingCellClasses: TableViewItemCell.self)
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
            case .signOutCompleted:
                navigationDelegate?.didSignOut(self)
            case let .showError(message):
                showAlert(message: message)
            case let .profileLoaded(name):
                nameLabel.text = name
            }
        }
        .store(in: &bag)
    }
    
    private func setupViews() {
//        navigationController?.navigationBar.topItem?.title = "Мой профиль"
        circularView.backgroundColor = UIColor.accent.withAlphaComponent(0.4)
        [circularView, profileImageView, nameLabel, phoneNumberLabel, tableView].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        circularView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
