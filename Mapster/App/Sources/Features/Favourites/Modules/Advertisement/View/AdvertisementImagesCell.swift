import UIKit

// Финальный класс для ячейки изображений объявления
final class AdvertisementImagesCell: UITableViewCell {
    // Ленивая инициализация scrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    // Инициализация stackView для размещения изображений
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    // Инициализация pageControl для отображения текущей страницы
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.backgroundStyle = .prominent
        return pageControl
    }()
    
    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Конфигурация ячейки с изображениями
    func configure(urls: [URL]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        pageControl.numberOfPages = urls.count
        for url in urls {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(scrollView.frameLayoutGuide)
            }
        }
    }
    
    // Настройка видов
    private func setupViews() {
        [scrollView, pageControl].forEach { contentView.addSubview($0) }
        scrollView.addSubview(stackView)
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(375)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.height.equalTo(scrollView)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - UIScrollViewDelegate

// Расширение для обработки делегата UIScrollView
extension AdvertisementImagesCell: UIScrollViewDelegate {
    // Обработка прокрутки scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
