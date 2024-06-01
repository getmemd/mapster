import UIKit

// Протокол делегата для навигации по объявлению
protocol AdvertisementNavigationDelegate: AnyObject {
    
}

// Финальный класс для контроллера объявления
final class AdvertisementViewController: BaseViewController {
    weak var navigationDelegate: AdvertisementNavigationDelegate?
    private let store: AdvertisementStore
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = AdvertisementTableViewDataSourceImpl(store: store)
    
    // Таблица для отображения данных объявления
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
    
    // Инициализация контроллера с хранилищем данных
    init(store: AdvertisementStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Загрузка вида
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
        store.handleAction(.viewDidLoad)
    }
    
    // Обработка нажатия на кнопку избранного
    @objc
    private func favouriteDidTap() {
        store.sendAction(.favouriteDidTap)
    }
    
    // Настройка правой кнопки в навигационной панели
    private func configureRightBarButton(isFavourite: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: isFavourite ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(favouriteDidTap)
        )
    }
    
    // Открытие координат в карте
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
    
    // Звонок по номеру телефона
    private func callByPhone(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else { return }
        UIApplication.shared.open(url)
    }
    
    // Настройка наблюдателей для событий
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableView.reloadData()
            case let .showError(message):
                showAlert(message: message)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            case let .userLoaded(isFavourite):
                configureRightBarButton(isFavourite: isFavourite)
            case let .openInMap(mapType, latitude, longitude):
                openInMap(mapType: mapType, latitude: latitude, longitude: longitude)
            case let .callByPhone(phoneNumber):
                callByPhone(phoneNumber: phoneNumber)
            }
        }
        .store(in: &bag)
    }
    
    // Настройка видов
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        configureRightBarButton(isFavourite: false)
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
