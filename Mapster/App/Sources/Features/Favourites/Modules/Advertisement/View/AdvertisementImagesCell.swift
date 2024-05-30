import UIKit

final class AdvertisementImagesCell: UITableViewCell {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.backgroundStyle = .prominent
        return pageControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func setupViews() {
        [scrollView, pageControl].forEach { contentView.addSubview($0) }
        scrollView.addSubview(stackView)
    }
    
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

extension AdvertisementImagesCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
