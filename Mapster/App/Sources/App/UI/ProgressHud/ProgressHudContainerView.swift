import UIKit

final class ProgressHudContainerView: UIView {
    private var backgroundView = UIView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    private func setupViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
        backgroundView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.078, alpha: 0.64)
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(48)
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
