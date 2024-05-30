import UIKit

protocol CreatePhotoCellDelegate: AnyObject {
    func didTapAddPhoto(_ cell: CreatePhotoCell)
    func didDeleteImage(_ cell: CreatePhotoCell, index: Int)
}

final class CreatePhotoCell: UITableViewCell {
    weak var delegate: CreatePhotoCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .semiBold, size: 16)
        label.text = "Фото"
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        return scrollView
    }()
    
    private lazy var photoStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(images: [Data]) {
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        configureEmptyView()
        images.enumerated().forEach {
            if let image = UIImage(data: $1) {
                let view = CreatePhotoView()
                view.delegate = self
                view.tag = $0
                view.configure(image: image)
                photoStackView.insertArrangedSubview(view, at: 0)
            }
        }
    }
    
    @objc
    private func didTapAddPhoto() {
        delegate?.didTapAddPhoto(self)
    }
    
    private func configureEmptyView() {
        let emptyView = CreatePhotoEmptyView()
        emptyView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddPhoto))
        emptyView.addGestureRecognizer(gesture)
        photoStackView.addArrangedSubview(emptyView)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        [titleLabel, scrollView].forEach { contentView.addSubview($0) }
        scrollView.addSubview(photoStackView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        photoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView)
        }
    }
}

// MARK: - CreatePhotoViewDelegate

extension CreatePhotoCell: CreatePhotoViewDelegate {
    func didTapDelete(_ view: CreatePhotoView) {
        delegate?.didDeleteImage(self, index: view.tag)
    }
}
