//
//  OnboardingViewController.swift
//  Mapster
//
//  Created by User on 15.02.2024.
//

import UIKit

// Протокол для делегата навигации в онбординге
protocol OnboardingNavigationDelegate: AnyObject {
    func didFinishOnboarding(_ viewController: OnboardingViewController) // Метод для завершения онбординга
}

final class OnboardingViewController: UIViewController {
    enum Constants {
        static let numberOfPages = 3 // Количество страниц в онбординге
    }
    
    var navigationDelegate: OnboardingNavigationDelegate?
    
    // UIScrollView для прокрутки страниц
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // Стек для отображения контента
    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // UIPageControl для отображения номера текущей страницы
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = Constants.numberOfPages
        pageControl.currentPageIndicatorTintColor = .accent
        pageControl.pageIndicatorTintColor = .lightGreen
        return pageControl
    }()
    
    // Изображение кнопки "Далее"
    private lazy var nextButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "next_button")
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapNextButton))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // Обработчик нажатия кнопки "Далее"
    @objc
    private func didTapNextButton() {
        guard Constants.numberOfPages > pageControl.currentPage + 1 else {
            navigationDelegate?.didFinishOnboarding(self) // Уведомление делегата о завершении онбординга
            return
        }
        let nextPageIndex = pageControl.currentPage + 1
        let targetOffsetX = CGFloat(nextPageIndex) * scrollView.frame.size.width
        let targetRect = CGRect(x: targetOffsetX, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        scrollView.scrollRectToVisible(targetRect, animated: true)
    }
    
    // Настройка представлений
    private func setupViews() {
        [scrollView, pageControl, nextButtonImageView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStackView)
        view.backgroundColor = .white
        for index in 0..<Constants.numberOfPages {
            let view = OnboardingView()
            view.configure(with: .init(index: index))
            contentStackView.addArrangedSubview(view)
        }
    }
    
    // Настройка констреинтов
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        contentStackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(scrollView.frameLayoutGuide)
        }
        pageControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalTo(nextButtonImageView)
        }
        nextButtonImageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(36)
            $0.size.equalTo(50)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {
    // Обработчик прокрутки UIScrollView для обновления UIPageControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
