//
//  AdvertisementViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.05.2024.
//

import UIKit

protocol AdvertisementNavigationDelegate: AnyObject {
    
}

final class AdvertisementViewController: BaseViewController {
    weak var navigationDelegate: AdvertisementNavigationDelegate?
    private let store: AdvertisementStore
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = AdvertisementTableViewDataSourceImpl(store: store)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 84
        tableView.register(bridgingCellClasses: AdvertisementImagesCell.self, AdvertisementInfoCell.self)
        tableView.clipsToBounds = false
        return tableView
    }()
    
    init(store: AdvertisementStore) {
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
    
    private func openInMap(mapType: MapType, latitude: Double, longitude: Double) {
        var link: String
        switch mapType {
        case .doubleGis:
            link = "https://2gis.ru/geo/\(longitude),\(latitude)"
        case .yandexMap:
            link = "https://yandex.ru/maps/?pt=\(longitude),\(latitude)&z=17&l=map"
        }
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    private func callByPhone(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else { return }
        UIApplication.shared.open(url)
    }
    
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableView.reloadData()
            case let .openInMap(mapType, latitude, longitude):
                openInMap(mapType: mapType, latitude: latitude, longitude: longitude)
            case let .callByPhone(phoneNumber):
                callByPhone(phoneNumber: phoneNumber)
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
