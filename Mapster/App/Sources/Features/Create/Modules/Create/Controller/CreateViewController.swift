import CoreLocation
import UIKit

// Протокол делегата для навигации создания
protocol CreateNavigationDelegate: AnyObject {
    func didTapMap(_ viewController: CreateViewController)
    func didCreateAdvertisement(_ viewController: CreateViewController)
}

// Финальный класс для контроллера создания
final class CreateViewController: BaseViewController {
    weak var navigationDelegate: CreateNavigationDelegate?
    private lazy var store = CreateStore()
    private var bag = Bag()
    private lazy var tableViewDataSourceImpl = CreateTableViewDataSourceImpl(store: store)
    
    // Таблица для отображения содержимого
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSourceImpl
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 84
        tableView.register(bridgingCellClasses: TitleCell.self,
                           CreatePhotoCell.self,
                           CreateDropDownCell.self,
                           CreateTextFieldCell.self,
                           CreateTextViewCell.self,
                           CreateMapCell.self)
        tableView.clipsToBounds = false
        return tableView
    }()
    
    // Метод viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureObservers()
        store.handleAction(.viewDidLoad)
    }
    
    // Обработка выбранного местоположения
    func didPickedLocation(latitude: Double, longitude: Double) {
        store.handleAction(.didPickLocation(latitude: latitude, longitude: longitude))
    }
    
    // Настройка наблюдателей
    private func configureObservers() {
        bindStore(store) { [weak self ] event in
            guard let self else { return }
            switch event {
            case let .rows(rows):
                tableViewDataSourceImpl.rows = rows
                tableView.reloadData()
            case .showImagePicker:
                showImagePicker()
            case .showMapPicker:
                navigationDelegate?.didTapMap(self)
            case .success:
                navigationDelegate?.didCreateAdvertisement(self)
            case let .showError(message):
                showAlert(message: message)
            case let .showToast(message):
                showToast(message: message)
            case .loading:
                ProgressHud.startAnimating()
            case .loadingFinished:
                ProgressHud.stopAnimating()
            }
        }
        .store(in: &bag)
    }
    
    // Показ выбора изображения
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true)
    }
    
    // Настройка видов
    private func setupViews() {
        view.addSubview(tableView)
        tableViewDataSourceImpl.tableView = tableView
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

// Расширение для обработки выбора изображений
extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            store.handleAction(.didPickImage(data: imageData))
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
